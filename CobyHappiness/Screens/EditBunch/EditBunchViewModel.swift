//
//  EditBunchViewModel.swift
//  CobyHappiness
//
//  Created by Coby on 6/16/24.
//

import Foundation

@Observable
final class EditBunchViewModel {
    
    @ObservationIgnored
    private let dataSource: ItemDataSource
    
    var memories: [Memory] = []
    var selectedMemories: [Memory] = []
    
    init(dataSource: ItemDataSource = ItemDataSource.shared) {
        self.dataSource = dataSource
        self.fetchMemories()
    }
    
    func fetchMemories() {
        self.memories = self.dataSource.fetchMemories()
    }
    
    func appendBunch(bunch: Bunch) {
        self.dataSource.appendBunch(bunch: bunch)
    }
}
