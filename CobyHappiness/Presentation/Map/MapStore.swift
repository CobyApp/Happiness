//
//  MapStore.swift
//  CobyHappiness
//
//  Created by Coby Kim on 6/27/24.
//

import Foundation

import ComposableArchitecture

struct MapStore: Reducer {
    
    @ObservableState
    struct State: Equatable {
        var appModel: AppViewModel
        var showingEditMemoryView: Bool = false
        var memories: [MemoryModel] = []
        var filteredMemories: [MemoryModel] = []
        
        init(appModel: AppViewModel) {
            self.appModel = appModel
        }
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case onAppear
        case showEditMemory
        case showMemoryDetail(MemoryModel)
        case getMemories
        case getMemoriesResponse(TaskResult<[MemoryModel]>)
    }
    
    @Dependency(\.mapClient) private var mapClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .onAppear:
                return .send(.getMemories)
            case .showEditMemory:
                state.showingEditMemoryView = true
                return .none
            case .showMemoryDetail(let memory):
                state.appModel.currentActiveItem = memory
                state.appModel.showDetailView = true
                return .none
            case .getMemories:
                return .run { send in
                    let result = await TaskResult {
                        try await mapClient.memories()
                    }
                    await send(.getMemoriesResponse(result))
                }
            case let .getMemoriesResponse(.success(memories)):
                state.memories = memories
                return .none
            case let .getMemoriesResponse(.failure(error)):
                print(error.localizedDescription)
                return .none
            }
        }
    }
}
