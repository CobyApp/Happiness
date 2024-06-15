//
//  BunchViewModel.swift
//  CobyHappiness
//
//  Created by Coby on 6/16/24.
//

import Foundation

@Observable
final class BunchViewModel {
    
    @ObservationIgnored
    private let dataSource: ItemDataSource
    
    var bunches: [Bunch] = []
    
    init(dataSource: ItemDataSource = ItemDataSource.shared) {
        self.dataSource = dataSource
        self.fetchBunches()
    }
    
    func fetchBunches() {
        self.bunches = self.dataSource.fetchBunches()
    }
}
