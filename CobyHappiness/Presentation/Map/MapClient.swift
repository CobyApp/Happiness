//
//  MapClient.swift
//  CobyHappiness
//
//  Created by Coby Kim on 6/27/24.
//

import Foundation

import ComposableArchitecture

struct MapClient {
    var memories: @Sendable () async throws -> [MemoryModel]
}

extension DependencyValues {
    var mapClient: MapClient {
        get { self[MapClient.self] }
        set { self[MapClient.self] = newValue }
    }
}

extension MapClient: DependencyKey {
    static let liveValue = MapClient(
        memories: {
            do {
                return try await AppUsecase(AppRepositoryImpl()).getMemories()
            } catch(let error) {
                throw error
            }
        }
    )
}

extension MapClient: TestDependencyKey {
    static let previewValue = Self(
        memories: { .init() }
    )

    static let testValue = Self(
        memories: unimplemented("\(Self.self)")
    )
}
