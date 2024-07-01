//
//  AppRepositoryImpl.swift
//  CobyHappiness
//
//  Created by Coby on 6/25/24.
//

import Foundation
import SwiftData

final class AppRepositoryImpl: AppRepository {
    
    private let container: ModelContainer
    
    init() {
        do {
            let config = ModelConfiguration(for: Bunch.self, Memory.self)
            self.container = try ModelContainer(for: Bunch.self, Memory.self, configurations: config)
        } catch {
            fatalError("Failed to configure SwiftData container.")
        }
    }
    
    @MainActor
    func getMemory(id: UUID) async throws -> Memory {
        let descriptor = FetchDescriptor<Memory>(predicate: #Predicate { $0.id == id })
        return try self.container.mainContext.fetch(descriptor).first!
    }
    
    @MainActor
    func getMemories() async throws -> [Memory] {
        let descriptor = FetchDescriptor<Memory>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        return try self.container.mainContext.fetch(descriptor)
    }
    
    @MainActor
    func saveMemory(request: SaveMemoryRequest) async throws {
        let memory = Memory(
            id: request.id,
            date: request.date,
            type: request.type,
            title: request.title,
            note: request.note,
            location: request.location,
            photos: request.photos
        )
        self.container.mainContext.insert(memory)
        return try self.container.mainContext.save()
    }
    
    @MainActor
    func deleteMemory(id: UUID) async throws {
        let memory = try await self.getMemory(id: id)
        return self.container.mainContext.delete(memory)
    }
    
    @MainActor
    func getBunch(id: UUID) async throws -> Bunch {
        let descriptor = FetchDescriptor<Bunch>(predicate: #Predicate { $0.id == id })
        return try self.container.mainContext.fetch(descriptor).first!
    }
    
    @MainActor
    func getBunches() async throws -> [Bunch] {
        let descriptor = FetchDescriptor<Bunch>(sortBy: [SortDescriptor(\.startDate, order: .reverse)])
        return try self.container.mainContext.fetch(descriptor)
    }
    
    @MainActor
    func saveBunch(request: SaveBunchRequest) async throws {
//        let memories = try await request.memories.asyncMap { try await self.getMemory(id: $0) }
        let bunch = Bunch(
            id: request.id,
            startDate: request.startDate,
            endDate: request.endDate,
            title: request.title
//            memories: memories
        )
        self.container.mainContext.insert(bunch)
        return try self.container.mainContext.save()
    }
    
    @MainActor
    func deleteBunch(id: UUID) async throws {
        let bunch = try await self.getBunch(id: id)
        return self.container.mainContext.delete(bunch)
    }
}
