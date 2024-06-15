//
//  BunchDetailViewModel.swift
//  CobyHappiness
//
//  Created by Coby on 6/16/24.
//

import Foundation

@Observable
final class BunchDetailViewModel {
    
    @ObservationIgnored
    private let dataSource: ItemDataSource
    
    init(dataSource: ItemDataSource = ItemDataSource.shared) {
        self.dataSource = dataSource
    }
    
    func removeBunch(bunch: Bunch) {
        self.dataSource.removeBunch(bunch)
    }
}
