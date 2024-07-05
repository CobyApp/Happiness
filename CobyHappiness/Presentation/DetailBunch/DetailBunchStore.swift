//
//  DetailBunchStore.swift
//  CobyHappiness
//
//  Created by Coby Kim on 6/27/24.
//

import UIKit

import ComposableArchitecture

@Reducer
struct DetailBunchStore: Reducer {
    
    @ObservableState
    struct State: Equatable {
        @Presents var detailMemory: DetailMemoryStore.State?
        @Presents var editBunch: EditBunchStore.State?
        @Presents var optionSheet: ConfirmationDialogState<OptionSheetAction>?
        @Presents var deleteAlert: AlertState<DeleteAlertAction>?
        var isPresented: Bool = true
        var scale: CGFloat = 1
        var isDown: Bool = false
        var bunch: BunchModel
        
        init(
            bunch: BunchModel
        ) {
            self.bunch = bunch
        }
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case detailMemory(PresentationAction<DetailMemoryStore.Action>)
        case editBunch(PresentationAction<EditBunchStore.Action>)
        case optionSheet(PresentationAction<OptionSheetAction>)
        case deleteAlert(PresentationAction<DeleteAlertAction>)
        case showOptionSheet
        case showDeleteAlert
        case showDetailMemory(MemoryModel)
        case showEditBunch(BunchModel)
        case deleteBunch(BunchModel)
        case deleteBunchResponse
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
    @Dependency(\.bunchData) private var bunchContext
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(\.isPresented):
                return .send(.dismiss)
            case .binding:
                return .none
            case .detailMemory:
                return .none
            case .editBunch:
                return .none
            case let .optionSheet(action):
                switch action {
                case .presented(.edit):
                    return .send(.showEditBunch(state.bunch))
                case .presented(.delete):
                    return .send(.showDeleteAlert)
                case .dismiss:
                    return .none
                }
            case let .deleteAlert(action):
                switch action {
                case .presented(.delete):
                    return .send(.deleteBunch(state.bunch))
                case .dismiss:
                    return .none
                }
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
                    title: TextState("추억 뭉치를 삭제하시겠습니까?"),
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
            case .showDetailMemory(let memory):
                state.detailMemory = DetailMemoryStore.State(memory: memory)
                return .none
            case .showEditBunch(let bunch):
                state.editBunch = EditBunchStore.State(bunch: bunch)
                return .none
            case .deleteBunch(let bunch):
                return .run { send in
                    let _ = await TaskResult {
                        try self.bunchContext.delete(bunch.id)
                    }
                    await send(.deleteBunchResponse)
                }
            case .deleteBunchResponse:
                return .send(.dismiss)
            case .dismiss:
                return .run { _ in await self.dismiss() }
            }
        }
        .ifLet(\.$detailMemory, action: \.detailMemory) {
            DetailMemoryStore()
        }
        .ifLet(\.$editBunch, action: \.editBunch) {
            EditBunchStore()
        }
        .ifLet(\.$optionSheet, action: \.optionSheet)
        .ifLet(\.$deleteAlert, action: \.deleteAlert)
    }
}
