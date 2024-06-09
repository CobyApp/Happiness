//
//  CobyHappinessApp.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 2023/09/21.
//

import SwiftUI

import CobyDS

@main
struct CobyHappinessApp: App {
    
    @StateObject var appModel: AppViewModel = .init()
    
    @Namespace private var animation
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .loadCustomFonts()
                .environmentObject(self.appModel)
                .namespace(self.animation)
                .modelContainer(for: Event.self)
        }
    }
}

class AppViewModel: ObservableObject {
    @Published var showDetailView: Bool = false
    @Published var currentActiveItem: Event?
}
