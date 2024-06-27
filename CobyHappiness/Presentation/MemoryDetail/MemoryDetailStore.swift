//
//  MemoryDetailStore.swift
//  CobyHappiness
//
//  Created by Coby Kim on 6/26/24.
//

import UIKit

import ComposableArchitecture

struct MemoryDetailStore: Reducer {
    
    @ObservableState
    struct State: Equatable {
        var appModel: AppViewModel
        var showingSheet = false
        var showingAlert = false
        var showingEditMemoryView: Bool = false
        var memory: MemoryModel
        var photos: [UIImage] = []
        
        init(
            appModel: AppViewModel,
            memory: MemoryModel
        ) {
            self.appModel = appModel
            self.memory = memory
        }
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case showOptionSheet
        case showDeleteAlert
        case showEditMemory
        case removeMemory(MemoryModel)
        case removeMemoryResponse
        case getPhotos
        case closeMemoryDetail
    }
    
    @Dependency(\.memoryDetailClient) private var memoryDetailClient
    
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
            case .showEditMemory:
                state.showingEditMemoryView = true
                return .none
            case .removeMemory(let memory):
                return .run { send in
                    let _ = await TaskResult {
                        try await memoryDetailClient.removeMemory(memory)
                    }
                    await send(.removeMemoryResponse)
                }
            case .removeMemoryResponse:
                return .send(.closeMemoryDetail)
            case .getPhotos:
                state.photos = state.memory.photos.compactMap { $0.image }
                return .none
            case .closeMemoryDetail:
                state.appModel.currentActiveItem = nil
                state.appModel.showDetailView = false
                return .none
            }
        }
    }
}
