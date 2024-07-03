//
//  MemoryDetailStore.swift
//  CobyHappiness
//
//  Created by Coby Kim on 6/26/24.
//

import UIKit
import SwiftData

import ComposableArchitecture
import Dependencies

struct MemoryDetailStore: Reducer {
    
    @ObservableState
    struct State: Equatable {
        var isPresented: Bool = true
        var showingSheet: Bool = false
        var showingAlert: Bool = false
        var showingEditMemoryView: Bool = false
        var memory: MemoryModel
        
        init(
            memory: MemoryModel
        ) {
            self.memory = memory
        }
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case showOptionSheet
        case showDeleteAlert
        case showEditMemory
        case deleteMemory(MemoryModel)
        case deleteMemoryResponse
        case getMemory(MemoryModel)
        case getMemoryResponse(TaskResult<MemoryModel>)
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
            case .showOptionSheet:
                state.showingSheet = true
                return .none
            case .showDeleteAlert:
                state.showingAlert = true
                return .none
            case .showEditMemory:
                state.showingEditMemoryView = true
                return .none
            case .deleteMemory(let memory):
                return .run { send in
                    let _ = await TaskResult {
                        try self.memoryContext.delete(memory)
                    }
                    await send(.deleteMemoryResponse)
                }
            case .deleteMemoryResponse:
                return .send(.dismiss)
            case .getMemory(let memory):
                return .run { send in
                    let result = await TaskResult {
                        return try self.memoryContext.fetchById(memory.id)
                    }
                    await send(.getMemoryResponse(result))
                }
            case let .getMemoryResponse(.success(memory)):
                state.memory = memory
                return .none
            case let .getMemoryResponse(.failure(error)):
                print(error.localizedDescription)
                return .none
            case .dismiss:
                state.isPresented = false
                return .none
            }
        }
    }
}
