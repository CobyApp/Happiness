//
//  ProfileStore.swift
//  CobyHappiness
//
//  Created by Coby Kim on 6/27/24.
//

import Foundation

import ComposableArchitecture

@Reducer
struct ProfileStore: Reducer {
    
    @ObservableState
    struct State: Equatable {
        @Presents var detailMemory: DetailMemoryStore.State?
        @Presents var setting: SettingStore.State?
        var memories: [MemoryModel] = []
        var memoryType: MemoryType? = nil
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case detailMemory(PresentationAction<DetailMemoryStore.Action>)
        case setting(PresentationAction<SettingStore.Action>)
        case showDetailMemory(MemoryModel)
        case getMemories
        case getMemoriesResponse(TaskResult<[MemoryModel]>)
        case navigateToSettingView
    }
    
    @Dependency(\.memoryData) private var memoryContext
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .detailMemory:
                return .none
            case .setting:
                return .none
            case .showDetailMemory(let memory):
                state.detailMemory = DetailMemoryStore.State(memory: memory)
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
            case .navigateToSettingView:
                return .none
            }
        }
        .ifLet(\.$detailMemory, action: \.detailMemory) {
            DetailMemoryStore()
        }
        .ifLet(\.$setting, action: \.setting) {
            SettingStore()
        }
    }
}
