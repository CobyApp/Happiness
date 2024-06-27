//
//  BunchStore.swift
//  CobyHappiness
//
//  Created by Coby Kim on 6/27/24.
//

import Foundation

import ComposableArchitecture

struct BunchStore: Reducer {
    
    @ObservableState
    struct State: Equatable {
        var showingEditBunchView: Bool = false
        var bunches: [BunchModel] = []
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case showEditBunch
        case showBunchDetail(BunchModel)
        case getBunches
        case getBunchesResponse(TaskResult<[BunchModel]>)
    }
    
    @Dependency(\.bunchClient) private var bunchClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .showEditBunch:
                state.showingEditBunchView = true
                return .none
            case .showBunchDetail(let bunch):
                return .none
            case .getBunches:
                return .run { send in
                    let result = await TaskResult {
                        try await bunchClient.bunches()
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
