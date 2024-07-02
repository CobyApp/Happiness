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
    var fetchAll: @Sendable () throws -> [BunchModel]
    var fetch: @Sendable (FetchDescriptor<Bunch>) throws -> [BunchModel]
    var add: @Sendable (BunchModel) throws -> Void
    var delete: @Sendable (BunchModel) throws -> Void
    
    enum BunchError: Error {
        case add
        case delete
    }
}

extension BunchDatabase: DependencyKey {
    public static let liveValue = Self(
        fetchAll: {
            do {
                @Dependency(\.databaseService.context) var context
                let bunchContext = try context()
                let descriptor = FetchDescriptor<Bunch>(sortBy: [SortDescriptor(\.startDate, order: .reverse)])
                return try bunchContext.fetch(descriptor).map { $0.toBunchModel() }
            } catch {
                return []
            }
        },
        fetch: { descriptor in
            do {
                @Dependency(\.databaseService.context) var context
                let bunchContext = try context()
                return try bunchContext.fetch(descriptor).map { $0.toBunchModel() }
            } catch {
                return []
            }
        },
        add: { model in
            do {
                @Dependency(\.databaseService.context) var context
                let bunchContext = try context()
                let bunch = model.toBunch()
                bunchContext.insert(bunch)
                bunch.memories = model.memories.map { $0.toMemory() }
                return try bunchContext.save()
            } catch {
                throw BunchError.add
            }
        },
        delete: { model in
            do {
                @Dependency(\.databaseService.context) var context
                let bunchContext = try context()
                bunchContext.delete(model.toBunch())
                return try bunchContext.save()
            } catch {
                throw BunchError.delete
            }
        }
    )
}

extension BunchDatabase: TestDependencyKey {
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
