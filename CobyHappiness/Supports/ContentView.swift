//
//  ContentView.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 10/4/23.
//

import SwiftUI

import CobyDS
import ComposableArchitecture

struct ContentView: View {
    
    init() {
        self.setupTabBarStyle()
    }
    
    var body: some View {
        NavigationStack {
            TabView {
                HomeView(store: Store(initialState: HomeStore.State()) {
                    HomeStore()
                })
                .tabItem {
                    Label("홈", image: "home")
                }
                
                MapView(store: Store(initialState: MapStore.State()) {
                    MapStore()
                })
                .tabItem {
                    Label("지도", image: "map")
                }
                
                BunchView(store: Store(initialState: BunchStore.State()) {
                    BunchStore()
                })
                .tabItem {
                    Label("뭉치", image: "travel")
                }
                
                ProfileView(store: Store(initialState: ProfileStore.State()) {
                    ProfileStore()
                })
                .tabItem {
                    Label("정보", image: "person")
                }
            }
        }
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
        itemAppearance.selected.iconColor = UIColor(Color.mainColor)
        itemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(Color.labelAlternative)]
        itemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(Color.mainColor)]
        
        tabBarAppearance.stackedLayoutAppearance = itemAppearance
        tabBarAppearance.inlineLayoutAppearance = itemAppearance
        tabBarAppearance.compactInlineLayoutAppearance = itemAppearance
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
