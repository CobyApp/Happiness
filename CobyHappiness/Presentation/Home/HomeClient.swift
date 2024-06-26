//
//  HomeClient.swift
//  CobyHappiness
//
//  Created by Coby Kim on 6/26/24.
//

import Foundation

import ComposableArchitecture

struct HomeClient {
    var memories: @Sendable () async throws -> [MemoryModel]
}

extension DependencyValues {
    var homeClient: HomeClient {
        get { self[HomeClient.self] }
        set { self[HomeClient.self] = newValue }
    }
}

extension HomeClient: DependencyKey {
    static let liveValue = HomeClient(
        memories: {
            do {
                return try await AppUsecase(AppRepositoryImpl()).getMemories()
            } catch(let error) {
                throw error
            }
        }
    )
}

extension HomeClient: TestDependencyKey {
    static let previewValue = Self(
        memories: { .init() }
    )

    static let testValue = Self(
        memories: unimplemented("\(Self.self)")
    )
}
