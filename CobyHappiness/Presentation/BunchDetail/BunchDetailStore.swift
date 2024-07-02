//
//  BunchDetailStore.swift
//  CobyHappiness
//
//  Created by Coby Kim on 6/27/24.
//

import UIKit

import ComposableArchitecture

struct BunchDetailStore: Reducer {
    
    @ObservableState
    struct State: Equatable {
        var appModel: AppViewModel
        var isPresented: Bool = true
        var showingSheet = false
        var showingAlert = false
        var showingEditBunchView: Bool = false
        var bunch: BunchModel
        
        init(
            appModel: AppViewModel,
            bunch: BunchModel
        ) {
            self.appModel = appModel
            self.bunch = bunch
        }
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case showOptionSheet
        case showDeleteAlert
        case showEditBunch
        case deleteBunch(BunchModel)
        case deleteBunchResponse
        case showMemoryDetail(MemoryModel)
        case dismiss
    }
    
    @Dependency(\.bunchData) private var bunchContext
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
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
            case .showMemoryDetail(let memory):
                state.appModel.currentActiveItem = memory
                state.appModel.showDetailView = true
                return .none
            case .dismiss:
                state.isPresented = false
                return .none
            }
        }
    }
}
