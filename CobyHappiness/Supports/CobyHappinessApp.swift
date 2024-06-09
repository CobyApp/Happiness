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
    
    @Namespace private var animation
    
    @StateObject var appModel: AppViewModel = .init()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .loadCustomFonts()
                .namespace(self.animation)
                .environmentObject(self.appModel)
                .modelContainer(for: Event.self)
        }
    }
}

class AppViewModel: ObservableObject {
    @Published var showDetailView: Bool = false
    @Published var currentActiveItem: Event?
}
