//
//  MemoryDetailStore.swift
//  CobyHappiness
//
//  Created by Coby Kim on 6/26/24.
//

import Foundation

import ComposableArchitecture

struct MemoryDetailStore: Reducer {
    
    struct State: Equatable {
        @BindingState var showingOptionAlert: Bool = false
        
        var memoryId: UUID?
        var memory: MemoryModel?
        var appModel: AppViewModel = .init()
        
        init(
            memoryId: UUID? = nil,
            memory: MemoryModel? = nil
        ) {
            self.memoryId = memoryId
            self.memory = memory
        }
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case onAppear(AppViewModel)
        case showOptionAlert
        case getMemory(UUID)
        case getMemoryResponse(TaskResult<MemoryModel>)
    }
    
    @Dependency(\.memoryDetailClient) private var memoryDetailClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(\.$showingOptionAlert):
                return .none
            case .binding:
                return .none
            case .onAppear(let appModel):
                state.appModel = appModel
                if let id = state.memoryId {
                    return .send(.getMemory(id))
                } else {
                    return .none
                }
            case .showOptionAlert:
                state.showingOptionAlert = true
                return .none
            case .getMemory(let id):
                return .run { send in
                    let result = await TaskResult {
                        try await memoryDetailClient.memory(id)
                    }
                    await send(.getMemoryResponse(result))
                }
            case let .getMemoryResponse(.success(memory)):
                state.memory = memory
                return .none
            case let .getMemoryResponse(.failure(error)):
                print(error.localizedDescription)
                return .none
            }
        }
    }
}
