//
//  EditMemoryStore.swift
//  CobyHappiness
//
//  Created by Coby Kim on 7/1/24.
//

import Foundation

import ComposableArchitecture

@Reducer
struct EditMemoryStore: Reducer {
    
    @ObservableState
    struct State: Equatable {
        var selection: PageType = .first
        var memory: MemoryModel
        
        init(
            memory: MemoryModel = MemoryModel()
        ) {
            self.memory = memory
        }
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case completeButtonTapped
        case saveMemory(MemoryModel)
        case saveMemoryResponse
        case dismiss
    }
    
    @Dependency(\.dismiss) private var dismiss
    @Dependency(\.memoryData) private var memoryContext
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .completeButtonTapped:
                switch state.selection {
                case .first:
                    state.selection = .second
                case .second:
                    guard !state.memory.isDisabled else { return .none }
                    return .send(.saveMemory(state.memory))
                }
                return .none
            case .saveMemory(let memory):
                let isFirst = state.memory.isFirst
                return .run { send in
                    let _ = await TaskResult {
                        try isFirst ? self.memoryContext.add(memory) : self.memoryContext.edit(memory)
                    }
                    await send(.saveMemoryResponse)
                }
            case .saveMemoryResponse:
                return .send(.dismiss)
            case .dismiss:
                return .run { _ in await self.dismiss() }
            }
        }
    }
}
