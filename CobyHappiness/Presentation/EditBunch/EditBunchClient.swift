//
//  EditBunchClient.swift
//  CobyHappiness
//
//  Created by Coby Kim on 7/1/24.
//

import Foundation

import ComposableArchitecture

struct EditBunchClient {
    var memories: @Sendable () async throws -> [MemoryModel]
    var saveBunch: @Sendable (BunchModel) async throws -> ()
}

extension DependencyValues {
    var editBunchClient: EditBunchClient {
        get { self[EditBunchClient.self] }
        set { self[EditBunchClient.self] = newValue }
    }
}

extension EditBunchClient: DependencyKey {
    static let liveValue = EditBunchClient(
        memories: {
            do {
                return try await AppUsecase(AppRepositoryImpl()).getMemories()
            } catch(let error) {
                throw error
            }
        },
        saveBunch: { bunch in
            do {
                let request = SaveBunchRequest(
                    id: bunch.id,
                    startDate: bunch.startDate,
                    endDate: bunch.endDate,
                    title: bunch.title,
                    memories: bunch.memories.map { $0.id }
                )
                return try await AppUsecase(AppRepositoryImpl()).saveBunch(request: request)
            } catch(let error) {
                throw error
            }
        }
    )
}

extension EditBunchClient: TestDependencyKey {
    static let previewValue = Self(
        memories: { .init() },
        saveBunch: { _ in }
    )

    static let testValue = Self(
        memories: unimplemented("\(Self.self)"),
        saveBunch: unimplemented("\(Self.self)")
    )
}
