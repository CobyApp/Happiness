//
//  BunchDetailClient.swift
//  CobyHappiness
//
//  Created by Coby Kim on 6/27/24.
//

import Foundation

import ComposableArchitecture

struct BunchDetailClient {
    var bunch: @Sendable (UUID) async throws -> BunchModel
    var deleteBunch: @Sendable (UUID) async throws -> ()
}

extension DependencyValues {
    var bunchDetailClient: BunchDetailClient {
        get { self[BunchDetailClient.self] }
        set { self[BunchDetailClient.self] = newValue }
    }
}

extension BunchDetailClient: DependencyKey {
    static let liveValue = BunchDetailClient(
        bunch: { id in
            do {
                return try await AppUsecase(AppRepositoryImpl()).getBunch(id: id)
            } catch(let error) {
                throw error
            }
        },
        deleteBunch: { id in
            do {
                return try await AppUsecase(AppRepositoryImpl()).deleteBunch(id: id)
            } catch(let error) {
                throw error
            }
        }
    )
}

extension BunchDetailClient: TestDependencyKey {
    static let previewValue = Self(
        bunch: { _ in .init() },
        deleteBunch: { _ in }
    )

    static let testValue = Self(
        bunch: unimplemented("\(Self.self)"),
        deleteBunch: unimplemented("\(Self.self)")
    )
}
