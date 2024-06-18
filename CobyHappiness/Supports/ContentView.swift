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
    
    init() {
        self.setupTabBarStyle()
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                TabView {
                    HomeView()
                        .tabItem {
                            Label("홈", image: "home")
                        }
                    
                    MapView()
                        .tabItem {
                            Label("지도", image: "map")
                        }
                    
                    BunchView()
                        .tabItem {
                            Label("뭉치", image: "travel")
                        }
                    
                    ProfileView()
                        .tabItem {
                            Label("정보", image: "person")
                        }
                }
                .opacity(self.appModel.showDetailView ? 0 : 1)
            }
            
            if let memory = self.appModel.currentActiveItem, self.appModel.showDetailView {
                MemoryDetailView(memory: memory)
            }
        }
        .environmentObject(self.appModel)
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
        itemAppearance.normal.iconColor = UIColor(Color.labelAlternative)
        itemAppearance.selected.iconColor = UIColor(Color.redNormal)
        itemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(Color.labelAlternative)]
        itemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(Color.redNormal)]
        
        tabBarAppearance.stackedLayoutAppearance = itemAppearance
        tabBarAppearance.inlineLayoutAppearance = itemAppearance
        tabBarAppearance.compactInlineLayoutAppearance = itemAppearance
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}
