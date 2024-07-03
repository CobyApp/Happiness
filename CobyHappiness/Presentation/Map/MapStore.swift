//
//  MapStore.swift
//  CobyHappiness
//
//  Created by Coby Kim on 6/27/24.
//

import Foundation

import ComposableArchitecture

@Reducer
struct MapStore: Reducer {
    
    @ObservableState
    struct State {
        var path = StackState<Path.State>()
        var showingEditMemoryView: Bool = false
        var memories: [MemoryModel] = []
        var filteredMemories: [MemoryModel] = []
    }
    
    enum Action: BindableAction {
        case path(StackActionOf<Path>)
        case binding(BindingAction<State>)
        case showEditMemory
        case getMemories
        case getMemoriesResponse(TaskResult<[MemoryModel]>)
    }
    
    @Reducer
    enum Path {
        case detailMemory(MemoryDetailStore)
        case editMemory(EditMemoryStore)
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
            case .showEditMemory:
                state.showingEditMemoryView = true
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
        .forEach(\.path, action: \.path)
    }
}
