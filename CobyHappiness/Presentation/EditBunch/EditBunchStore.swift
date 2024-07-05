//
//  EditBunchStore.swift
//  CobyHappiness
//
//  Created by Coby Kim on 7/1/24.
//

import UIKit
import SwiftUI

import ComposableArchitecture

@Reducer
struct EditBunchStore: Reducer {
    
    @ObservableState
    struct State: Equatable {
        var showingAlert = false
        var memories: [MemoryModel] = []
        var bunch: BunchModel
        
        init(
            bunch: BunchModel = BunchModel()
        ) {
            self.bunch = bunch
        }
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case getMemories
        case getMemoriesResponse(TaskResult<[MemoryModel]>)
        case saveBunch(BunchModel)
        case saveBunchResponse
        case showTitleAlert
        case dismiss
    }
    
    @Dependency(\.dismiss) private var dismiss
    @Dependency(\.bunchData) private var bunchContext
    @Dependency(\.memoryData) private var memoryContext
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
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
            case .saveBunch(let bunch):
                return .run { send in
                    let _ = await TaskResult {
                        try self.bunchContext.add(bunch)
                    }
                    await send(.saveBunchResponse)
                }
            case .saveBunchResponse:
                return .send(.dismiss)
            case .showTitleAlert:
                state.bunch.startDate = state.bunch.memories.map { $0.date }.min() ?? .now
                state.bunch.endDate = state.bunch.memories.map { $0.date }.max() ?? .now
                state.showingAlert = true
                return .none
            case .dismiss:
                return .run { _ in await self.dismiss() }
            }
        }
    }
}
