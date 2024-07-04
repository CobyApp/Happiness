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
    struct State: Equatable {
        @Presents var addMemory: EditMemoryStore.State?
        @Presents var detailMemory: DetailMemoryStore.State?
        var showingEditMemoryView: Bool = false
        var topLeft: LocationModel? = nil
        var bottomRight: LocationModel? = nil
        var memories: [MemoryModel] = []
        var filteredMemories: [MemoryModel] = []
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case addMemory(PresentationAction<EditMemoryStore.Action>)
        case detailMemory(PresentationAction<DetailMemoryStore.Action>)
        case showAddMemory
        case showDetailMemory(MemoryModel)
        case getMemories
        case getMemoriesResponse(TaskResult<[MemoryModel]>)
        case filterMemory
    }
    
    @Dependency(\.memoryData) private var memoryContext
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(\.topLeft):
                return .send(.filterMemory)
            case .binding(\.bottomRight):
                return .send(.filterMemory)
            case .binding:
                return .none
            case .addMemory:
                return .none
            case .detailMemory:
                return .none
            case .showAddMemory:
                state.addMemory = EditMemoryStore.State()
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
                return .send(.filterMemory)
            case let .getMemoriesResponse(.failure(error)):
                print(error.localizedDescription)
                return .none
            case .filterMemory:
                guard let topLeft = state.topLeft else { return .none }
                guard let bottomRight = state.bottomRight else { return .none }
                state.filteredMemories = state.memories.filter { memory in
                    guard let location = memory.location else { return false }
                    return location.lat <= topLeft.lat &&
                    location.lat >= bottomRight.lat &&
                    location.lon >= topLeft.lon &&
                    location.lon <= bottomRight.lon
                }
                return .none
            }
        }
        .ifLet(\.$addMemory, action: \.addMemory) {
            EditMemoryStore()
        }
        .ifLet(\.$detailMemory, action: \.detailMemory) {
            DetailMemoryStore()
        }
    }
}
