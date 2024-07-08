//
//  BunchDatabase.swift
//  CobyHappiness
//
//  Created by Coby on 7/2/24.
//

import Foundation
import SwiftData
import Dependencies

extension DependencyValues {
    var bunchData: BunchDatabase {
        get { self[BunchDatabase.self] }
        set { self[BunchDatabase.self] = newValue }
    }
}

struct BunchDatabase {
    var fetch: @Sendable (FetchDescriptor<Bunch>) throws -> [BunchModel]
    var fetchAll: @Sendable () throws -> [BunchModel]
    var fetchById: @Sendable (UUID) throws -> BunchModel
    var add: @Sendable (BunchModel) throws -> Void
    var edit: @Sendable (BunchModel) throws -> Void
    var delete: @Sendable (UUID) throws -> Void
    var deleteAll: @Sendable () throws -> Void
    
    enum BunchError: Error {
        case get
        case add
        case edit
        case delete
    }
}

extension BunchDatabase: DependencyKey {
    public static let liveValue = Self(
        fetch: { descriptor in
            do {
                @Dependency(\.databaseService.context) var context
                let modelContext = try context()
                return try modelContext.fetch(descriptor).map { $0.toBunchModel() }
            } catch {
                return []
            }
        },
        fetchAll: {
            do {
                @Dependency(\.databaseService.context) var context
                let modelContext = try context()
                let descriptor = FetchDescriptor<Bunch>(sortBy: [SortDescriptor(\.startDate, order: .reverse)])
                return try modelContext.fetch(descriptor).map { $0.toBunchModel() }
            } catch {
                return []
            }
        },
        fetchById: { id in
            do {
                @Dependency(\.databaseService.context) var context
                let modelContext = try context()
                let descriptor = FetchDescriptor<Bunch>(predicate: #Predicate { $0.id == id })
                return try modelContext.fetch(descriptor).first!.toBunchModel()
            } catch {
                throw BunchError.get
            }
        },
        add: { model in
            do {
                @Dependency(\.databaseService.context) var context
                let modelContext = try context()
                let bunch = model.toBunch()
                modelContext.insert(bunch)
                bunch.memories = try model.memories.map {
                    let id = $0.id
                    let descriptor = FetchDescriptor<Memory>(predicate: #Predicate { $0.id == id })
                    let memory = try modelContext.fetch(descriptor).first!
                    return memory
                }
                return try modelContext.save()
            } catch {
                throw BunchError.add
            }
        },
        edit: { model in
            do {
                @Dependency(\.databaseService.context) var context
                let modelContext = try context()
                let id = model.id
                let descriptor = FetchDescriptor<Bunch>(predicate: #Predicate { $0.id == id })
                let bunch = try modelContext.fetch(descriptor).first!
                bunch.startDate = model.startDate
                bunch.endDate = model.endDate
                bunch.title = model.title
                bunch.image = model.imageData
                bunch.memories = try model.memories.map {
                    let id = $0.id
                    let descriptor = FetchDescriptor<Memory>(predicate: #Predicate { $0.id == id })
                    let memory = try modelContext.fetch(descriptor).first!
                    return memory
                }
                return try modelContext.save()
            } catch {
                throw BunchError.edit
            }
        },
        delete: { id in
            do {
                @Dependency(\.databaseService.context) var context
                let modelContext = try context()
                let descriptor = FetchDescriptor<Bunch>(predicate: #Predicate { $0.id == id })
                let bunch = try modelContext.fetch(descriptor).first!
                modelContext.delete(bunch)
                return try modelContext.save()
            } catch {
                throw BunchError.delete
            }
        },
        deleteAll: {
            do {
                @Dependency(\.databaseService.context) var context
                let modelContext = try context()
                try modelContext.delete(model: Bunch.self)
                try modelContext.delete(model: Memory.self)
                return try modelContext.save()
            } catch {
                throw BunchError.delete
            }
        }
    )
}

extension BunchDatabase: TestDependencyKey {
    public static var previewValue = Self.noop
    
    public static let testValue = Self(
        fetch: unimplemented("\(Self.self).fetchDescriptor"),
        fetchAll: unimplemented("\(Self.self).fetch"),
        fetchById: unimplemented("\(Self.self).fetchById"),
        add: unimplemented("\(Self.self).add"),
        edit: unimplemented("\(Self.self).edit"),
        delete: unimplemented("\(Self.self).delete"),
        deleteAll: unimplemented("\(Self.self).deleteAll")
    )
    
    static let noop = Self(
        fetch: { _ in [] },
        fetchAll: { [] },
        fetchById: { _ in .init() },
        add: { _ in },
        edit: { _ in },
        delete: { _ in },
        deleteAll: { }
    )
}

