//
//  MapViewModel.swift
//  CobyHappiness
//
//  Created by Coby on 6/16/24.
//

import Foundation

@Observable
final class MapViewModel {
    
    @ObservationIgnored
    private let dataSource: ItemDataSource
    
    var memories: [Memory] = []
    var filteredMemories: [Memory] = []
    
    init(dataSource: ItemDataSource = ItemDataSource.shared) {
        self.dataSource = dataSource
        self.fetchMemories()
    }
    
    func fetchMemories() {
        self.memories = self.dataSource.fetchMemories()
    }
}
