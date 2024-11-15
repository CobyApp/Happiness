//
//  DetailMemoryStore.swift
//  CobyHappiness
//
//  Created by Coby Kim on 6/26/24.
//

import UIKit
import SwiftData

import ComposableArchitecture
import Dependencies

@Reducer
struct DetailMemoryStore: Reducer {
    
    @ObservableState
    struct State: Equatable {
        @Presents var editMemory: EditMemoryStore.State?
        @Presents var optionSheet: ConfirmationDialogState<OptionSheetAction>?
        @Presents var deleteAlert: AlertState<DeleteAlertAction>?
        @Presents var confirmAlert: AlertState<Action>?
        var memory: MemoryModel
        
        init(
            memory: MemoryModel
        ) {
            self.memory = memory
        }
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case editMemory(PresentationAction<EditMemoryStore.Action>)
        case optionSheet(PresentationAction<OptionSheetAction>)
        case deleteAlert(PresentationAction<DeleteAlertAction>)
        case confirmAlert(PresentationAction<Action>)
        case showOptionSheet
        case showDeleteAlert
        case showConfirmAlert
        case showEditMemory(MemoryModel)
        case deleteMemory(MemoryModel)
        case deleteMemoryResponse
        case getMemory
        case getMemoryResponse(TaskResult<MemoryModel>)
        case dismiss
    }
    
    enum OptionSheetAction: Equatable {
        case edit
        case delete
    }
    
    enum DeleteAlertAction: Equatable {
        case delete
    }
    
    @Dependency(\.dismiss) private var dismiss
    @Dependency(\.memoryData) private var memoryContext
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .editMemory:
                return .none
            case let .optionSheet(action):
                switch action {
                case .presented(.edit):
                    return .send(.showEditMemory(state.memory))
                case .presented(.delete):
                    return .send(.showDeleteAlert)
                case .dismiss:
                    return .none
                }
            case let .deleteAlert(action):
                switch action {
                case .presented(.delete):
                    return .send(.deleteMemory(state.memory))
                case .dismiss:
                    return .none
                }
            case .confirmAlert:
                return .send(.dismiss)
            case .showOptionSheet:
                state.optionSheet = ConfirmationDialogState(
                    title: TextState("원하는 옵션을 선택해주세요."),
                    message: nil,
                    buttons: [
                        .default(
                            TextState("편집"),
                            action: .send(.edit)
                        ),
                        .destructive(
                            TextState("삭제"),
                            action: .send(.delete)
                        ),
                        .cancel(
                            TextState("취소")
                        )
                    ]
                )
                return .none
            case .showDeleteAlert:
                state.deleteAlert = AlertState(
                    title: TextState("추억을 삭제하시겠습니까?"),
                    message: nil,
                    buttons: [
                        .destructive(
                            TextState("삭제"),
                            action: .send(.delete)
                        ),
                        .cancel(
                            TextState("취소")
                        )
                    ]
                )    
                return .none
            case .showConfirmAlert:
                state.confirmAlert = AlertState(
                    title: TextState("추억이 삭제되었습니다."),
                    message: nil,
                    buttons: [
                        .default(
                            TextState("확인")
                        )
                    ]
                )
                return .none
            case .showEditMemory(let memory):
                state.editMemory = EditMemoryStore.State(memory: memory)
                return .none
            case .deleteMemory(let memory):
                return .run { send in
                    let _ = await TaskResult {
                        try self.memoryContext.delete(memory.id)
                    }
                    await send(.deleteMemoryResponse)
                }
            case .deleteMemoryResponse:
                return .send(.showConfirmAlert)
            case .getMemory:
                let id = state.memory.id
                return .run { send in
                    let result = await TaskResult {
                        return try self.memoryContext.fetchById(id)
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
                return .run { _ in await self.dismiss() }
            }
        }
        .ifLet(\.$editMemory, action: \.editMemory) {
            EditMemoryStore()
        }
        .ifLet(\.$optionSheet, action: \.optionSheet)
        .ifLet(\.$deleteAlert, action: \.deleteAlert)
        .ifLet(\.$confirmAlert, action: \.confirmAlert)
    }
}
