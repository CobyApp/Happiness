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
    struct State {
        var path = StackState<Path.State>()
        var memories: [MemoryModel] = []
        var memoryType: MemoryType? = nil
    }
    
    enum Action: BindableAction {
        case path(StackActionOf<Path>)
        case binding(BindingAction<State>)
        case getMemories
        case getMemoriesResponse(TaskResult<[MemoryModel]>)
        case navigateToSettingView
    }
    
    @Reducer
    enum Path {
        case detailMemory(MemoryDetailStore)
    }
    
    @Dependency(\.memoryData) private var memoryContext
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .path:
                return .none
            case .binding:
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
        .forEach(\.path, action: \.path)
    }
}
