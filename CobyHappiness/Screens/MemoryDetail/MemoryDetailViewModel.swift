//
//  MemoryDetailViewModel.swift
//  CobyHappiness
//
//  Created by Coby on 6/16/24.
//

import Foundation

@Observable
final class MemoryDetailViewModel {
    
    @ObservationIgnored
    private let dataSource: ItemDataSource
    
    var memories: [Memory] = []
    
    init(dataSource: ItemDataSource = ItemDataSource.shared) {
        self.dataSource = dataSource
    }
    
    func removeMemory(memory: Memory) {
        self.dataSource.removeMemory(memory)
    }
}
