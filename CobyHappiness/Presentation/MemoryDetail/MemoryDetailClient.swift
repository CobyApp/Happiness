//
//  MemoryDetailClient.swift
//  CobyHappiness
//
//  Created by Coby Kim on 6/26/24.
//

import Foundation

import ComposableArchitecture

struct MemoryDetailClient {
    var memory: @Sendable (UUID) async throws -> MemoryModel
    var deleteMemory: @Sendable (UUID) async throws -> ()
}

extension DependencyValues {
    var memoryDetailClient: MemoryDetailClient {
        get { self[MemoryDetailClient.self] }
        set { self[MemoryDetailClient.self] = newValue }
    }
}

extension MemoryDetailClient: DependencyKey {
    static let liveValue = MemoryDetailClient(
        memory: { id in
            do {
                return try await AppUsecase(AppRepositoryImpl()).getMemory(id: id)
            } catch(let error) {
                throw error
            }
        },
        deleteMemory: { id in
            do {
                return try await AppUsecase(AppRepositoryImpl()).deleteMemory(id: id)
            } catch(let error) {
                throw error
            }
        }
    )
}

extension MemoryDetailClient: TestDependencyKey {
    static let previewValue = Self(
        memory: { _ in .init() },
        deleteMemory: { _ in }
    )

    static let testValue = Self(
        memory: unimplemented("\(Self.self)"),
        deleteMemory: unimplemented("\(Self.self)")
    )
}
