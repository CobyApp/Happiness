//
//  CobyHappinessApp.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 2023/09/21.
//

import SwiftUI

import CobyDS
import ComposableArchitecture

@main
struct CobyHappinessApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(store: Store(initialState: RootStore.State()) {
                RootStore()
            })
            .loadCustomFonts()
        }
    }
}
