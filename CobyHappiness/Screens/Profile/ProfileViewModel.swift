//
//  ProfileViewModel.swift
//  CobyHappiness
//
//  Created by Coby on 6/18/24.
//

import Foundation

@Observable
final class ProfileViewModel {
    
    @ObservationIgnored
    private let dataSource: ItemDataSource
    
    var memories: [Memory] = []
    
    init(dataSource: ItemDataSource = ItemDataSource.shared) {
        self.dataSource = dataSource
        self.fetchMemories()
    }
    
    func fetchMemories() {
        self.memories = self.dataSource.fetchMemories()
    }
    
    func getFilteredMemory(_ type: MemoryType?) -> [Memory] {
        if let type = type {
            self.memories.filter { $0.type == type }
        } else {
            self.memories
        }
    }
    
    func getMemoryCount(_ type: MemoryType?) -> Int {
        self.getFilteredMemory(type).count
    }
}
