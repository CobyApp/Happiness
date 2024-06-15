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
    
    init(dataSource: ItemDataSource = ItemDataSource.shared) {
        self.dataSource = dataSource
        self.fetchMemories()
    }
    
    func fetchMemories() {
        self.memories = self.dataSource.fetchMemories()
    }
    
    func appendBunch(selectedMemories: [Memory]) {
        let bunch = Bunch(
            date: selectedMemories.first?.date ?? Date.now,
            title: selectedMemories.first?.title ?? "제목",
            note: selectedMemories.first?.note ?? "내용",
            memories: []
        )
        bunch.memories = selectedMemories
        self.dataSource.appendBunch(bunch: bunch)
    }
}
