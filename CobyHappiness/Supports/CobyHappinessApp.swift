//
//  CobyHappinessApp.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 2023/09/21.
//

import SwiftUI
import SwiftData

@main
struct CobyHappinessApp: App {
    var body: some Scene {
        WindowGroup {
            Main()
        }
        .modelContainer(for: Paper.self)
    }
}
