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
        case deleteBunch(UUID)
        case deleteBunchResponse
        case showMemoryDetail(MemoryModel)
        case dismiss
    }
    
    @Dependency(\.dismiss) private var dismiss
    @Dependency(\.bunchDetailClient) private var bunchDetailClient
    
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
            case .deleteBunch(let id):
                return .run { send in
                    let _ = await TaskResult {
                        try await self.bunchDetailClient.deleteBunch(id)
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
                return .run { send in
                    await self.dismiss()
                }
            }
        }
    }
}
