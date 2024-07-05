//
//  MemoryDatabase.swift
//  CobyHappiness
//
//  Created by Coby on 7/3/24.
//

import Foundation
import SwiftData
import Dependencies

extension DependencyValues {
    var memoryData: MemoryDatabase {
        get { self[MemoryDatabase.self] }
        set { self[MemoryDatabase.self] = newValue }
    }
}

struct MemoryDatabase {
    var fetch: @Sendable (FetchDescriptor<Memory>) throws -> [MemoryModel]
    var fetchAll: @Sendable () throws -> [MemoryModel]
    var fetchById: @Sendable (UUID) throws -> MemoryModel
    var add: @Sendable (MemoryModel) throws -> Void
    var edit: @Sendable (MemoryModel) throws -> Void
    var delete: @Sendable (UUID) throws -> Void
    
    enum MemoryError: Error {
        case get
        case add
        case edit
        case delete
    }
}

extension MemoryDatabase: DependencyKey {
    public static let liveValue = Self(
        fetch: { descriptor in
            do {
                @Dependency(\.databaseService.context) var context
                let memoryContext = try context()
                return try memoryContext.fetch(descriptor).map { $0.toMemoryModel() }
            } catch {
                return []
            }
        },
        fetchAll: {
            do {
                @Dependency(\.databaseService.context) var context
                let memoryContext = try context()
                let descriptor = FetchDescriptor<Memory>(sortBy: [SortDescriptor(\.date, order: .reverse)])
                return try memoryContext.fetch(descriptor).map { $0.toMemoryModel() }
            } catch {
                return []
            }
        },
        fetchById: { id in
            do {
                @Dependency(\.databaseService.context) var context
                let memoryContext = try context()
                let descriptor = FetchDescriptor<Memory>(predicate: #Predicate { $0.id == id })
                return try memoryContext.fetch(descriptor).first!.toMemoryModel()
            } catch {
                throw MemoryError.get
            }
        },
        add: { model in
            do {
                @Dependency(\.databaseService.context) var context
                let memoryContext = try context()
                memoryContext.insert(model.toMemory())
                return try memoryContext.save()
            } catch {
                throw MemoryError.add
            }
        },
        edit: { model in
            do {
                @Dependency(\.databaseService.context) var context
                let memoryContext = try context()
                let id = model.id
                let descriptor = FetchDescriptor<Memory>(predicate: #Predicate { $0.id == id })
                let memory = try memoryContext.fetch(descriptor).first!
                memory.date = model.date
                memory.type = model.type
                memory.title = model.title
                memory.note = model.note
                memory.location = model.location
                memory.photos = model.photosData
                return try memoryContext.save()
            } catch {
                throw MemoryError.edit
            }
        },
        delete: { id in
            do {
                @Dependency(\.databaseService.context) var context
                let memoryContext = try context()
                let descriptor = FetchDescriptor<Memory>(predicate: #Predicate { $0.id == id })
                let memory = try memoryContext.fetch(descriptor).first!
                memoryContext.delete(memory)
                return try memoryContext.save()
            } catch {
                throw MemoryError.delete
            }
        }
    )
}

extension MemoryDatabase: TestDependencyKey {
    public static var previewValue = Self.noop
    
    public static let testValue = Self(
        fetch: unimplemented("\(Self.self).fetchDescriptor"),
        fetchAll: unimplemented("\(Self.self).fetch"),
        fetchById: unimplemented("\(Self.self).fetchById"),
        add: unimplemented("\(Self.self).add"),
        edit: unimplemented("\(Self.self).add"),
        delete: unimplemented("\(Self.self).delete")
    )
    
    static let noop = Self(
        fetch: { _ in [] },
        fetchAll: { [] },
        fetchById: { _ in .init() },
        add: { _ in },
        edit: { _ in },
        delete: { _ in }
    )
}
