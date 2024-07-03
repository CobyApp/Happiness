//
//  BunchStore.swift
//  CobyHappiness
//
//  Created by Coby Kim on 6/27/24.
//

import Foundation

import ComposableArchitecture

@Reducer
struct BunchStore: Reducer {
    
    @ObservableState
    struct State: Equatable {
        var showingEditBunchView: Bool = false
        var bunches: [BunchModel] = []
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case showEditBunch
        case getBunches
        case getBunchesResponse(TaskResult<[BunchModel]>)
    }
    
    @Dependency(\.bunchData) private var bunchContext
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .showEditBunch:
                state.showingEditBunchView = true
                return .none
            case .getBunches:
                return .run { send in
                    let result = await TaskResult {
                        try self.bunchContext.fetchAll()
                    }
                    await send(.getBunchesResponse(result))
                }
            case let .getBunchesResponse(.success(bunches)):
                state.bunches = bunches
                return .none
            case let .getBunchesResponse(.failure(error)):
                print(error.localizedDescription)
                return .none
            }
        }
    }
}
