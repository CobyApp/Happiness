//
//  AppDatabase.swift
//  CobyHappiness
//
//  Created by Coby on 7/2/24.
//

import Foundation
import SwiftData
import Dependencies

extension DependencyValues {
    var swiftData: AppDatabase {
        get { self[AppDatabase.self] }
        set { self[AppDatabase.self] = newValue }
    }
}

struct AppDatabase {
    
    // Bunch
    var fetchAllBunch: @Sendable () throws -> [BunchModel]
    var fetchBunch: @Sendable (FetchDescriptor<Bunch>) throws -> [BunchModel]
    var addBunch: @Sendable (BunchModel) throws -> Void
    var deleteBunch: @Sendable (BunchModel) throws -> Void
    
    // Memory
    var fetchAllMemory: @Sendable () throws -> [MemoryModel]
    var fetchMemory: @Sendable (FetchDescriptor<Memory>) throws -> [MemoryModel]
    var addMemory: @Sendable (MemoryModel) throws -> Void
    var deleteMemory: @Sendable (MemoryModel) throws -> Void
    
    // Error
    enum AppError: Error {
        case addBunch
        case deleteBunch
        case addMemory
        case deleteMemory
    }
}

extension AppDatabase: DependencyKey {
    public static let liveValue = Self(
        fetchAllBunch: {
            do {
                @Dependency(\.databaseService.context) var context
                let bunchContext = try context()
                let descriptor = FetchDescriptor<Bunch>(sortBy: [SortDescriptor(\.startDate, order: .reverse)])
                return try bunchContext.fetch(descriptor).map { $0.toBunchModel() }
            } catch {
                return []
            }
        },
        fetchBunch: { descriptor in
            do {
                @Dependency(\.databaseService.context) var context
                let bunchContext = try context()
                return try bunchContext.fetch(descriptor).map { $0.toBunchModel() }
            } catch {
                return []
            }
        },
        addBunch: { model in
            do {
                @Dependency(\.databaseService.context) var context
                let bunchContext = try context()
                bunchContext.insert(model.toBunch())
            } catch {
                throw AppError.addBunch
            }
        },
        deleteBunch: { model in
            do {
                @Dependency(\.databaseService.context) var context
                let bunchContext = try context()
                bunchContext.delete(model.toBunch())
            } catch {
                throw AppError.deleteBunch
            }
        },
        fetchAllMemory: {
            do {
                @Dependency(\.databaseService.context) var context
                let memoryContext = try context()
                let descriptor = FetchDescriptor<Memory>(sortBy: [SortDescriptor(\.date, order: .reverse)])
                return try memoryContext.fetch(descriptor).map { $0.toMemoryModel() }
            } catch {
                return []
            }
        },
        fetchMemory: { descriptor in
            do {
                @Dependency(\.databaseService.context) var context
                let memoryContext = try context()
                return try memoryContext.fetch(descriptor).map { $0.toMemoryModel() }
            } catch {
                return []
            }
        },
        addMemory: { model in
            do {
                @Dependency(\.databaseService.context) var context
                let memoryContext = try context()
                memoryContext.insert(model.toMemory())
            } catch {
                throw AppError.addMemory
            }
        },
        deleteMemory: { model in
            do {
                @Dependency(\.databaseService.context) var context
                let memoryContext = try context()
                memoryContext.delete(model.toMemory())
            } catch {
                throw AppError.deleteMemory
            }
        }
    )
}

extension AppDatabase: TestDependencyKey {
    public static var previewValue = Self.noop
    
    public static let testValue = Self(
        fetchAllBunch: unimplemented("\(Self.self).fetch"),
        fetchBunch: unimplemented("\(Self.self).fetchDescriptor"),
        addBunch: unimplemented("\(Self.self).add"),
        deleteBunch: unimplemented("\(Self.self).delete"),
        fetchAllMemory: unimplemented("\(Self.self).fetch"),
        fetchMemory: unimplemented("\(Self.self).fetchDescriptor"),
        addMemory: unimplemented("\(Self.self).add"),
        deleteMemory: unimplemented("\(Self.self).delete")
    )
    
    static let noop = Self(
        fetchAllBunch: { [] },
        fetchBunch: { _ in [] },
        addBunch: { _ in },
        deleteBunch: { _ in },
        fetchAllMemory: { [] },
        fetchMemory: { _ in [] },
        addMemory: { _ in },
        deleteMemory: { _ in }
    )
}
