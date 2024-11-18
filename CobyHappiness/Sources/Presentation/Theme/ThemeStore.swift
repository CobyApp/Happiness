//
//  ThemeStore.swift
//  CobyHappiness
//
//  Created by Coby Kim on 7/8/24.
//

import SwiftUI

import ComposableArchitecture

@Reducer
struct ThemeStore: Reducer {
    
    @ObservableState
    struct State: Equatable {
        var selectedColorType: ColorType = UserDefaults.standard.string(forKey: "mainColor")?.toColorType ?? ColorType.red
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case saveColor(ColorType)
        case dismiss
    }
    
    @Dependency(\.dismiss) private var dismiss
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .saveColor(let colorType):
                UserDefaults.standard.set(colorType.rawValue, forKey: "mainColor")
                self.setupTabBarStyle()
                return .send(.dismiss)
            case .dismiss:
                return .run { _ in await self.dismiss() }
            }
        }
    }
}

extension ThemeStore {
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
