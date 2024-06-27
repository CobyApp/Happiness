//
//  BunchClient.swift
//  CobyHappiness
//
//  Created by Coby Kim on 6/27/24.
//

import Foundation

import ComposableArchitecture

struct BunchClient {
    var bunches: @Sendable () async throws -> [BunchModel]
}

extension DependencyValues {
    var bunchClient: BunchClient {
        get { self[BunchClient.self] }
        set { self[BunchClient.self] = newValue }
    }
}

extension BunchClient: DependencyKey {
    static let liveValue = BunchClient(
        bunches: {
            do {
                return try await AppUsecase(AppRepositoryImpl()).getBunches()
            } catch(let error) {
                throw error
            }
        }
    )
}

extension BunchClient: TestDependencyKey {
    static let previewValue = Self(
        bunches: { .init() }
    )

    static let testValue = Self(
        bunches: unimplemented("\(Self.self)")
    )
}
