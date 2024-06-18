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
    var bunches: [Bunch] = []
    
    init(dataSource: ItemDataSource = ItemDataSource.shared) {
        self.dataSource = dataSource
        self.fetchMemories()
        self.fetchBunches()
    }
    
    func fetchMemories() {
        self.memories = self.dataSource.fetchMemories()
    }
    
    func fetchBunches() {
        self.bunches = self.dataSource.fetchBunches()
    }
}
