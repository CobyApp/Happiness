//
//  HomeStore.swift
//  CobyHappiness
//
//  Created by Coby Kim on 6/26/24.
//

import Foundation

import ComposableArchitecture

@Reducer
struct HomeStore: Reducer {
    
    @ObservableState
    struct State: Equatable {
        @Presents var addMemory: EditMemoryStore.State?
        @Presents var detailMemory: MemoryDetailStore.State?
        var memories: [MemoryModel] = []
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case addMemory(PresentationAction<EditMemoryStore.Action>)
        case detailMemory(PresentationAction<MemoryDetailStore.Action>)
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
            case .addMemory:
                return .none
            case .detailMemory:
                return .none
            case .showEditMemory:
                state.addMemory = EditMemoryStore.State()
                return .none
            case .showMemoryDetail(let memory):
                state.detailMemory = MemoryDetailStore.State(memory: memory)
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
        .ifLet(\.$addMemory, action: \.addMemory) {
            EditMemoryStore()
        }
        .ifLet(\.$detailMemory, action: \.detailMemory) {
            MemoryDetailStore()
        }
    }
}
