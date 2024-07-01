//
//  EditMemoryClient.swift
//  CobyHappiness
//
//  Created by Coby Kim on 7/1/24.
//

import Foundation

import ComposableArchitecture

struct EditMemoryClient {
    var saveMemory: @Sendable (MemoryModel) async throws -> ()
}

extension DependencyValues {
    var editMemoryClient: EditMemoryClient {
        get { self[EditMemoryClient.self] }
        set { self[EditMemoryClient.self] = newValue }
    }
}

extension EditMemoryClient: DependencyKey {
    static let liveValue = EditMemoryClient(
        saveMemory: { memory in
            do {
                return try await AppUsecase(AppRepositoryImpl()).saveMemory(memory: memory)
            } catch(let error) {
                throw error
            }
        }
    )
}

extension EditMemoryClient: TestDependencyKey {
    static let previewValue = Self(
        saveMemory: { _ in }
    )

    static let testValue = Self(
        saveMemory: unimplemented("\(Self.self)")
    )
}
