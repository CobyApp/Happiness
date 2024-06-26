//
//  AppViewModel.swift
//  CobyHappiness
//
//  Created by Coby on 6/18/24.
//

import SwiftUI

class AppViewModel: ObservableObject, Equatable {
    static func == (lhs: AppViewModel, rhs: AppViewModel) -> Bool {
        lhs.showDetailView == rhs.showDetailView
    }
    
    @Published var showDetailView: Bool = false
    @Published var currentActiveItem: MemoryModel? = nil
}
