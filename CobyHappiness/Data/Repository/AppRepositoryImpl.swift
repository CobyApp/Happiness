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
        self.container = try! ModelContainer(for: Bunch.self)
    }
    
    @MainActor
    func getMemories() async throws -> [Memory] {
        let descriptor = FetchDescriptor<Memory>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        return try self.container.mainContext.fetch(descriptor)
    }
    
    @MainActor
    func saveMemory(memory: Memory) async throws {
        self.container.mainContext.insert(memory)
        return try self.container.mainContext.save()
    }
    
    @MainActor
    func removeMemory(memory: Memory) async throws {
        self.container.mainContext.delete(memory)
    }
    
    @MainActor
    func getBunches() async throws -> [Bunch] {
        let descriptor = FetchDescriptor<Bunch>(sortBy: [SortDescriptor(\.startDate, order: .reverse)])
        return try self.container.mainContext.fetch(descriptor)
    }
    
    @MainActor
    func saveBunch(bunch: Bunch) async throws {
        self.container.mainContext.insert(bunch)
        return try self.container.mainContext.save()
    }
    
    @MainActor
    func removeBunch(bunch: Bunch) async throws {
        self.container.mainContext.delete(bunch)
    }
}
