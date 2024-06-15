//
//  EditMemoryViewModel.swift
//  CobyHappiness
//
//  Created by Coby on 6/16/24.
//

import Foundation

@Observable
final class EditMemoryViewModel {
    
    @ObservationIgnored
    private let dataSource: ItemDataSource
    
    init(dataSource: ItemDataSource = ItemDataSource.shared) {
        self.dataSource = dataSource
    }
    
    func appendMemory(memory: Memory) {
        self.dataSource.appendMemory(memory: memory)
    }
}
