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
    var fetch: @Sendable (FetchDescriptor<Memory>) throws -> [MemoryModel]
    var add: @Sendable (MemoryModel) throws -> Void
    var delete: @Sendable (MemoryModel) throws -> Void
    
    enum MemoryError: Error {
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
                let memory = model.toMemory()
                memory.photos = model.photos.map { $0.compressedImage }
                memoryContext.insert(memory)
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
        fetch: unimplemented("\(Self.self).fetchDescriptor"),
        add: unimplemented("\(Self.self).add"),
        delete: unimplemented("\(Self.self).delete")
    )
    
    static let noop = Self(
        fetchAll: { [] },
        fetch: { _ in [] },
        add: { _ in },
        delete: { _ in }
    )
}
