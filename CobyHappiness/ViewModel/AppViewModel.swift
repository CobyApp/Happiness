//
//  AppViewModel.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 10/4/23.
//

import SwiftUI

class AppViewModel: ObservableObject {
    @Published var currentTab: Tab = .home
    @Published var showDetailView: Bool = false
    @Published var currentActiveItem: Event?
}
