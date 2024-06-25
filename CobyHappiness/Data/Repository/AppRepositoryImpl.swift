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
        self.container = try! ModelContainer(for: BunchModel.self, MemoryModel.self)
    }
    
    @MainActor
    func getMemories() async throws -> [MemoryModel] {
        let descriptor = FetchDescriptor<MemoryModel>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        return try self.container.mainContext.fetch(descriptor)
    }
    
    @MainActor
    func saveMemory(memory: MemoryModel) throws {
        self.container.mainContext.insert(memory)
        return try self.container.mainContext.save()
    }
    
    @MainActor
    func removeMemory(memory: MemoryModel) throws {
        self.container.mainContext.delete(memory)
    }
    
    @MainActor
    func getBunches() async throws -> [BunchModel] {
        let descriptor = FetchDescriptor<BunchModel>(sortBy: [SortDescriptor(\.startDate, order: .reverse)])
        return try self.container.mainContext.fetch(descriptor)
    }
    
    @MainActor
    func saveBunch(bunch: BunchModel) throws {
        self.container.mainContext.insert(bunch)
        return try self.container.mainContext.save()
    }
    
    @MainActor
    func removeBunch(bunch: BunchModel) throws {
        self.container.mainContext.delete(bunch)
    }
}
