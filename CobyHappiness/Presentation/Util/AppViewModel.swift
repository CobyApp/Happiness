//
//  AppViewModel.swift
//  CobyHappiness
//
//  Created by Coby on 6/18/24.
//

import SwiftUI

class AppViewModel: ObservableObject {
    @Published var showDetailView: Bool = false
    @Published var currentActiveItem: MemoryModel? = nil
}
