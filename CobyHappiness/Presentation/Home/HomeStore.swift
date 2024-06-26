//
//  HomeStore.swift
//  CobyHappiness
//
//  Created by Coby Kim on 6/26/24.
//

import Foundation

import ComposableArchitecture

struct HomeStore: Reducer {
    
    struct State: Equatable {
        @BindingState var showingEditMemoryView = false
        
        var memories: [MemoryModel] = []
        var appModel: AppViewModel = .init()
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case onAppear(AppViewModel)
        case showEditMemory
        case showMemoryDetail(MemoryModel)
        case getMemories
        case getMemoriesResponse(TaskResult<[MemoryModel]>)
    }
    
    @Dependency(\.homeClient) private var homeClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(\.$showingEditMemoryView):
                return .none
            case .binding:
                return .none
            case .onAppear(let appModel):
                state.appModel = appModel
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
                        try await homeClient.memories()
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
