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
            let config = ModelConfiguration(for: BunchModel.self, MemoryModel.self)
            self.container = try ModelContainer(for: BunchModel.self, MemoryModel.self, configurations: config)
        } catch {
            fatalError("Failed to configure SwiftData container.")
        }
    }
    
    @MainActor
    func getMemoryById(id: UUID) async throws -> MemoryModel? {
        do {
            let descriptor = FetchDescriptor<MemoryModel>(predicate: #Predicate { $0.id == id })
            return try self.container.mainContext.fetch(descriptor).first
        } catch {
            return nil
        }
    }
    
    @MainActor
    func getMemories() async throws -> [MemoryModel] {
        let descriptor = FetchDescriptor<MemoryModel>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        return try self.container.mainContext.fetch(descriptor)
    }
    
    @MainActor
    func saveMemory(memory: MemoryModel) async throws {
        self.container.mainContext.insert(memory)
        return try self.container.mainContext.save()
    }
    
    @MainActor
    func removeMemory(memory: MemoryModel) async throws {
        self.container.mainContext.delete(memory)
    }
    
    @MainActor
    func getBunchById(id: UUID) async throws -> BunchModel? {
        do {
            let descriptor = FetchDescriptor<BunchModel>(predicate: #Predicate { $0.id == id })
            return try self.container.mainContext.fetch(descriptor).first
        } catch {
            return nil
        }
    }
    
    @MainActor
    func getBunches() async throws -> [BunchModel] {
        let descriptor = FetchDescriptor<BunchModel>(sortBy: [SortDescriptor(\.startDate, order: .reverse)])
        return try self.container.mainContext.fetch(descriptor)
    }
    
    @MainActor
    func saveBunch(bunch: BunchModel) async throws {
        self.container.mainContext.insert(bunch)
        return try self.container.mainContext.save()
    }
    
    @MainActor
    func removeBunch(bunch: BunchModel) async throws {
        self.container.mainContext.delete(bunch)
    }
}
