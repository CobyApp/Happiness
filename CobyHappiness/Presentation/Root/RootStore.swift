//
//  RootStore.swift
//  CobyHappiness
//
//  Created by Coby on 7/4/24.
//

import Foundation

import ComposableArchitecture

@Reducer
struct RootStore: Reducer {
    
    @ObservableState
    struct State {
        var path = StackState<Path.State>()
    }
    
    enum Action {
        case path(StackActionOf<Path>)
    }
    
    @Reducer
    enum Path {
        case detailBunch(BunchDetailStore)
        case editBunch(EditBunchStore)
        case detailMemory(MemoryDetailStore)
        case editMemory(EditMemoryStore)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
