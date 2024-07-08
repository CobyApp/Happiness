//
//  ThemeStore.swift
//  CobyHappiness
//
//  Created by Coby Kim on 7/8/24.
//

import Foundation

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
                return .send(.dismiss)
            case .dismiss:
                return .run { _ in await self.dismiss() }
            }
        }
    }
}
