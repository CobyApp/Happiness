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
    var body: some Scene {
        WindowGroup {
            ContentView()
                .loadCustomFonts()
                .modelContainer(for: Event.self)
        }
    }
}
