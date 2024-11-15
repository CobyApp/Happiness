//
//  SettingStore.swift
//  CobyHappiness
//
//  Created by Coby Kim on 7/5/24.
//

import Foundation

import ComposableArchitecture

@Reducer
struct SettingStore: Reducer {
    
    @ObservableState
    struct State: Equatable {
        @Presents var theme: ThemeStore.State?
        @Presents var deleteAlert: AlertState<DeleteAlertAction>?
        @Presents var confirmAlert: AlertState<Action>?
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case theme(PresentationAction<ThemeStore.Action>)
        case deleteAlert(PresentationAction<DeleteAlertAction>)
        case confirmAlert(PresentationAction<Action>)
        case showThemeView
        case showDeleteAlert
        case showConfirmAlert
        case deleteAll
        case deleteAllResponse
        case dismiss
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
            case .binding:
                return .none
            case .theme:
                return .none
            case let .deleteAlert(action):
                switch action {
                case .presented(.delete):
                    return .send(.deleteAll)
                case .dismiss:
                    return .none
                }
            case .confirmAlert:
                return .none
            case .showThemeView:
                state.theme = ThemeStore.State()
                return .none
            case .showDeleteAlert:
                state.deleteAlert = AlertState(
                    title: TextState("모든 데이터를 삭제하시겠습니까?"),
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
                    title: TextState("모든 데이터가 삭제되었습니다."),
                    message: nil,
                    buttons: [
                        .default(
                            TextState("확인")
                        )
                    ]
                )
                return .none
            case .deleteAll:
                return .run { send in
                    let _ = await TaskResult {
                        try self.bunchContext.deleteAll()
                    }
                    await send(.deleteAllResponse)
                }
            case .deleteAllResponse:
                return .send(.showConfirmAlert)
            case .dismiss:
                return .run { _ in await self.dismiss() }
            }
        }
        .ifLet(\.$theme, action: \.theme) {
            ThemeStore()
        }
        .ifLet(\.$deleteAlert, action: \.deleteAlert)
        .ifLet(\.$confirmAlert, action: \.confirmAlert)
    }
}
