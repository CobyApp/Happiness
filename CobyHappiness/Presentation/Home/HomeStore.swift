//
//  HomeStore.swift
//  CobyHappiness
//
//  Created by Coby Kim on 6/26/24.
//

import Foundation

import ComposableArchitecture

struct HomeStore: Reducer {
    
    @ObservableState
    struct State: Equatable {
        var appModel: AppViewModel
        var showingEditMemoryView: Bool = false
        var memories: [MemoryModel] = []
        
        init(appModel: AppViewModel) {
            self.appModel = appModel
        }
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case showEditMemory
        case showMemoryDetail(MemoryModel)
        case getMemories
        case getMemoriesResponse(TaskResult<[MemoryModel]>)
    }
    
    @Dependency(\.memoryData) private var memoryContext
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
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
                        try self.memoryContext.fetchAll()
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
