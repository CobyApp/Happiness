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
    var removeMemory: @Sendable (UUID) async throws -> ()
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
        removeMemory: { id in
            do {
                return try await AppUsecase(AppRepositoryImpl()).removeMemory(id: id)
            } catch(let error) {
                throw error
            }
        }
    )
}

extension MemoryDetailClient: TestDependencyKey {
    static let previewValue = Self(
        memory: { _ in .init() },
        removeMemory: { _ in }
    )

    static let testValue = Self(
        memory: unimplemented("\(Self.self)"),
        removeMemory: unimplemented("\(Self.self)")
    )
}
