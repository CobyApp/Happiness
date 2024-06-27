//
//  ProfileClient.swift
//  CobyHappiness
//
//  Created by Coby Kim on 6/27/24.
//

import Foundation

import ComposableArchitecture

struct ProfileClient {
    var memories: @Sendable () async throws -> [MemoryModel]
}

extension DependencyValues {
    var profileClient: ProfileClient {
        get { self[ProfileClient.self] }
        set { self[ProfileClient.self] = newValue }
    }
}

extension ProfileClient: DependencyKey {
    static let liveValue = ProfileClient(
        memories: {
            do {
                return try await AppUsecase(AppRepositoryImpl()).getMemories()
            } catch(let error) {
                throw error
            }
        }
    )
}

extension ProfileClient: TestDependencyKey {
    static let previewValue = Self(
        memories: { .init() }
    )

    static let testValue = Self(
        memories: unimplemented("\(Self.self)")
    )
}
