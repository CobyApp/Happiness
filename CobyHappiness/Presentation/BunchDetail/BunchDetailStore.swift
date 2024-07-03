//
//  BunchDetailStore.swift
//  CobyHappiness
//
//  Created by Coby Kim on 6/27/24.
//

import UIKit

import ComposableArchitecture

@Reducer
struct BunchDetailStore: Reducer {
    
    @ObservableState
    struct State {
        var path = StackState<Path.State>()
        var isPresented: Bool = true
        var showingSheet: Bool = false
        var showingAlert: Bool = false
        var showingEditBunchView: Bool = false
        var bunch: BunchModel
        
        init(
            bunch: BunchModel
        ) {
            self.bunch = bunch
        }
    }
    
    enum Action: BindableAction {
        case path(StackActionOf<Path>)
        case binding(BindingAction<State>)
        case showOptionSheet
        case showDeleteAlert
        case showEditBunch
        case deleteBunch(BunchModel)
        case deleteBunchResponse
        case dismiss
    }
    
    @Reducer
    enum Path {
        case detailMemory(MemoryDetailStore)
    }
    
    @Dependency(\.bunchData) private var bunchContext
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .path:
                return .none
            case .binding:
                return .none
            case .showOptionSheet:
                state.showingSheet = true
                return .none
            case .showDeleteAlert:
                state.showingAlert = true
                return .none
            case .showEditBunch:
                state.showingEditBunchView = true
                return .none
            case .deleteBunch(let bunch):
                return .run { send in
                    let _ = await TaskResult {
                        try self.bunchContext.delete(bunch)
                    }
                    await send(.deleteBunchResponse)
                }
            case .deleteBunchResponse:
                return .send(.dismiss)
            case .dismiss:
                state.isPresented = false
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
