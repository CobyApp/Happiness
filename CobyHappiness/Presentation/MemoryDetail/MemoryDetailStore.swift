//
//  MemoryDetailStore.swift
//  CobyHappiness
//
//  Created by Coby Kim on 6/26/24.
//

import UIKit

import ComposableArchitecture

struct MemoryDetailStore: Reducer {
    
    @ObservableState
    struct State: Equatable {
        var appModel: AppViewModel
        var showingSheet = false
        var showingAlert = false
        var showingEditMemoryView: Bool = false
        var memoryId: UUID?
        var memory: MemoryModel?
        var photos: [UIImage] = []
        
        init(
            appModel: AppViewModel,
            memoryId: UUID? = nil,
            memory: MemoryModel? = nil
        ) {
            self.appModel = appModel
            self.memoryId = memoryId
            self.memory = memory
        }
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case onAppear
        case showOptionSheet
        case showDeleteAlert
        case showEditMemory
        case removeMemory(MemoryModel)
        case removeMemoryResponse
        case getMemory(UUID)
        case getMemoryResponse(TaskResult<MemoryModel>)
        case getPhotos(MemoryModel)
        case closeMemoryDetail
    }
    
    @Dependency(\.memoryDetailClient) private var memoryDetailClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .onAppear:
                if let id = state.memoryId {
                    return .send(.getMemory(id))
                } else {
                    return .send(.getPhotos(state.memory ?? .init()))
                }
            case .showOptionSheet:
                state.showingSheet = true
                return .none
            case .showDeleteAlert:
                state.showingAlert = true
                return .none
            case .showEditMemory:
                state.showingEditMemoryView = true
                return .none
            case .removeMemory(let memory):
                return .run { send in
                    let result = await TaskResult {
                        try await memoryDetailClient.removeMemory(memory)
                    }
                    await send(.removeMemoryResponse)
                }
            case .removeMemoryResponse:
                return .send(.closeMemoryDetail)
            case .getMemory(let id):
                return .run { send in
                    let result = await TaskResult {
                        try await memoryDetailClient.memory(id)
                    }
                    await send(.getMemoryResponse(result))
                }
            case let .getMemoryResponse(.success(memory)):
                state.memory = memory
                return .send(.getPhotos(memory))
            case let .getMemoryResponse(.failure(error)):
                print(error.localizedDescription)
                return .none
            case .getPhotos(let memory):
                state.photos = memory.photos.compactMap { $0.image }
                return .none
            case .closeMemoryDetail:
                state.appModel.currentActiveItem = nil
                state.appModel.showDetailView = false
                return .none
            }
        }
    }
}
