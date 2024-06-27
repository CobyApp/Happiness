//
//  ProfileStore.swift
//  CobyHappiness
//
//  Created by Coby Kim on 6/27/24.
//

import Foundation

import ComposableArchitecture

struct ProfileStore: Reducer {
    
    @ObservableState
    struct State: Equatable {
        var appModel: AppViewModel
        var memories: [MemoryModel] = []
        var memoryType: MemoryType? = nil
        
        init(appModel: AppViewModel) {
            self.appModel = appModel
        }
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case showMemoryDetail(MemoryModel)
        case getMemories
        case getMemoriesResponse(TaskResult<[MemoryModel]>)
        case navigateToSettingView
    }
    
    @Dependency(\.profileClient) private var profileClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .showMemoryDetail(let memory):
                state.appModel.currentActiveItem = memory
                state.appModel.showDetailView = true
                return .none
            case .getMemories:
                return .run { send in
                    let result = await TaskResult {
                        try await profileClient.memories()
                    }
                    await send(.getMemoriesResponse(result))
                }
            case let .getMemoriesResponse(.success(memories)):
                state.memories = memories
                return .none
            case let .getMemoriesResponse(.failure(error)):
                print(error.localizedDescription)
                return .none
            case .navigateToSettingView:
                return .none
            }
        }
    }
}
