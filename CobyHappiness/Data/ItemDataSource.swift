//
//  ItemDataSource.swift
//  CobyHappiness
//
//  Created by Coby on 6/16/24.
//

import Foundation
import SwiftData

final class ItemDataSource {
    
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    @MainActor
    static let shared = ItemDataSource()

    @MainActor
    private init() {
        self.modelContainer = try! ModelContainer(for: Bunch.self)
        self.modelContext = modelContainer.mainContext
    }
    
    // Memory
    func appendMemory(memory: Memory) {
        self.modelContext.insert(memory)
        do {
            try self.modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func fetchMemories() -> [Memory] {
        do {
            let descriptor = FetchDescriptor<Memory>(sortBy: [SortDescriptor(\.date, order: .reverse)])
            return try self.modelContext.fetch(descriptor)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func removeMemory(_ memory: Memory) {
        self.modelContext.delete(memory)
    }
    
    // Bunch
    func appendBunch(bunch: Bunch) {
        self.modelContext.insert(bunch)
        do {
            try self.modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func fetchBunches() -> [Bunch] {
        do {
            let descriptor = FetchDescriptor<Bunch>(sortBy: [SortDescriptor(\.date, order: .reverse)])
            return try self.modelContext.fetch(descriptor)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func removeBunch(_ bunch: Bunch) {
        self.modelContext.delete(bunch)
    }
}
