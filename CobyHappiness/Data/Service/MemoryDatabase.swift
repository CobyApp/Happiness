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
    var fetchAll: @Sendable () throws -> [MemoryModel]
    var fetchById: @Sendable (UUID) throws -> MemoryModel
    var fetch: @Sendable (FetchDescriptor<Memory>) throws -> [MemoryModel]
    var add: @Sendable (MemoryModel) throws -> Void
    var delete: @Sendable (MemoryModel) throws -> Void
    
    enum MemoryError: Error {
        case get
        case add
        case delete
    }
}

extension MemoryDatabase: DependencyKey {
    public static let liveValue = Self(
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
        fetch: { descriptor in
            do {
                @Dependency(\.databaseService.context) var context
                let memoryContext = try context()
                return try memoryContext.fetch(descriptor).map { $0.toMemoryModel() }
            } catch {
                return []
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
        delete: { model in
            do {
                @Dependency(\.databaseService.context) var context
                let memoryContext = try context()
                memoryContext.delete(model.toMemory())
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
        fetchAll: unimplemented("\(Self.self).fetch"),
        fetchById: unimplemented("\(Self.self).fetchById"),
        fetch: unimplemented("\(Self.self).fetchDescriptor"),
        add: unimplemented("\(Self.self).add"),
        delete: unimplemented("\(Self.self).delete")
    )
    
    static let noop = Self(
        fetchAll: { [] },
        fetchById: { _ in .init() },
        fetch: { _ in [] },
        add: { _ in },
        delete: { _ in }
    )
}
