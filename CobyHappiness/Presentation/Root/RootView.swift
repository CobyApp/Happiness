//
//  RootView.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 10/4/23.
//

import SwiftUI

import CobyDS
import ComposableArchitecture

struct RootView: View {
    
    @Bindable private var store: StoreOf<RootStore>
    
    init(store: StoreOf<RootStore>) {
        self.store = store
        self.setupTabBarStyle()
    }
    
    var body: some View {
        NavigationStack(
            path: self.$store.scope(state: \.path, action: \.path)
        ) {
            TabRootView()
        } destination: { store in
            switch store.case {
            case .detailBunch(let store):
                BunchDetailView(store: store)
                    .navigationBarHidden(true)
            case .editBunch(let store):
                EditBunchView(store: store)
                    .navigationBarHidden(true)
            case .detailMemory(let store):
                MemoryDetailView(store: store)
                    .navigationBarHidden(true)
            case .editMemory(let store):
                EditMemoryView(store: store)
                    .navigationBarHidden(true)
            }
        }
    }
    
    @ViewBuilder
    private func TabRootView() -> some View {
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

extension RootView {
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
