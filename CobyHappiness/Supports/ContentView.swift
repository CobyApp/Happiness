//
//  ContentView.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 10/4/23.
//

import SwiftUI

import CobyDS

struct ContentView: View {
    
    @StateObject var appModel: AppViewModel = .init()
    
    @Namespace private var animation
    
    init() {
        self.setupTabBarStyle()
    }
    
    var body: some View {
        ZStack {
            TabView {
                Home(animation: self.animation)
                    .tabItem {
                        Label("홈", image: "home")
                    }
                
                Home(animation: self.animation)
                    .tabItem {
                        Label("지도", image: "map")
                    }
                
                Home(animation: self.animation)
                    .tabItem {
                        Label("여행", image: "travel")
                    }
                
                Home(animation: self.animation)
                    .tabItem {
                        Label("정보", image: "person")
                    }
            }
            .opacity(self.appModel.showDetailView ? 0 : 1)
            
            if let event = self.appModel.currentActiveItem, self.appModel.showDetailView {
                Detail(event: event, animation: self.animation)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .environmentObject(self.appModel)
        .modelContainer(for: Event.self)
    }
}

extension ContentView {
    private func setupTabBarStyle() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(Color.backgroundNormalNormal)
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.iconColor = UIColor(Color.labelNormal)
        itemAppearance.selected.iconColor = UIColor(Color.redNormal)
        itemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(Color.labelNormal)]
        itemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(Color.redNormal)]
        
        tabBarAppearance.stackedLayoutAppearance = itemAppearance
        tabBarAppearance.inlineLayoutAppearance = itemAppearance
        tabBarAppearance.compactInlineLayoutAppearance = itemAppearance

        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}

class AppViewModel: ObservableObject {
    @Published var showDetailView: Bool = false
    @Published var currentActiveItem: Event?
}
