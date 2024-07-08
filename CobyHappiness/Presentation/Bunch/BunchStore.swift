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
        @Presents var addBunch: EditBunchStore.State?
        @Presents var detailBunch: DetailBunchStore.State?
        var bunches: [BunchModel] = []
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case addBunch(PresentationAction<EditBunchStore.Action>)
        case detailBunch(PresentationAction<DetailBunchStore.Action>)
        case showAddBunch
        case showDetailBunch(BunchModel)
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
            case .addBunch:
                return .none
            case .detailBunch:
                return .none
            case .showAddBunch:
                state.addBunch = EditBunchStore.State()
                return .none
            case .showDetailBunch(let bunch):
                state.detailBunch = DetailBunchStore.State(bunch: bunch)
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
        .ifLet(\.$addBunch, action: \.addBunch) {
            EditBunchStore()
        }
        .ifLet(\.$detailBunch, action: \.detailBunch) {
            DetailBunchStore()
        }
    }
}
