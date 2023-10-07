//
//  Main.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 10/4/23.
//

import SwiftUI

struct Main: View {
    @StateObject var appModel: AppViewModel = .init()
    
    @Namespace var animation
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        TabView(selection: $appModel.currentTab) {
            Home(animation: animation)
                .environmentObject(appModel)
                .tag(Tab.home)
                .setUpTab()
            
            Text("Cart")
                .tag(Tab.cart)
                .setUpTab()
            
            Text("Favourite")
                .tag(Tab.favourite)
                .setUpTab()
            
            Text("Profile")
                .tag(Tab.profile)
                .setUpTab()
        }
        .overlay(alignment: .bottom) {
            CustomTabBar(currentTab: $appModel.currentTab, animation: animation)
                .offset(y: appModel.showDetailView ? 150 : 0)
        }
        .overlay {
            if let event = appModel.currentActiveItem, appModel.showDetailView {
                Detail(event: event, animation: animation)
                    .environmentObject(appModel)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .modelContainer(for: Event.self)
    }
}

// MARK: Custom Extensions
extension View {
    @ViewBuilder
    func setUpTab() -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Color(Color.backgroundLightGray)
                    .ignoresSafeArea()
            }
    }
}
