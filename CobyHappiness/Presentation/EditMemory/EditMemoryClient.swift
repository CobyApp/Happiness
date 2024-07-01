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
                let request = SaveMemoryRequest(
                    id: memory.id,
                    date: memory.date,
                    type: memory.type,
                    title: memory.title,
                    note: memory.note,
                    location: memory.location,
                    photos: memory.photos.map { $0.compressImage }
                )
                return try await AppUsecase(AppRepositoryImpl()).saveMemory(request: request)
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
