//
//  SettingStore.swift
//  CobyHappiness
//
//  Created by Coby Kim on 7/5/24.
//

import Foundation

import ComposableArchitecture

@Reducer
struct SettingStore: Reducer {
    
    @ObservableState
    struct State: Equatable {
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case dismiss
    }
    
    @Dependency(\.dismiss) private var dismiss
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .dismiss:
                return .run { _ in await self.dismiss() }
            }
        }
    }
}
