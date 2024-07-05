//
//  EditMemoryStore.swift
//  CobyHappiness
//
//  Created by Coby Kim on 7/1/24.
//

import UIKit
import SwiftUI
import MapKit
import PhotosUI

import ComposableArchitecture

@Reducer
struct EditMemoryStore: Reducer {
    
    @ObservableState
    struct State: Equatable {
        var isDisabled: Bool = true
        var memory: MemoryModel
        var selectedItems: [PhotosPickerItem] = []
        
        init(
            memory: MemoryModel = MemoryModel()
        ) {
            self.memory = memory
        }
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case setType(MemoryType)
        case saveMemory(MemoryModel)
        case saveMemoryResponse
        case checkDisabled
        case dismiss
    }
    
    @Dependency(\.dismiss) private var dismiss
    @Dependency(\.memoryData) private var memoryContext
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(\.memory):
                return .send(.checkDisabled)
            case .binding(\.selectedItems):
                (state.memory.photos, state.memory.date, state.memory.location) = self.setPhotos(items: state.selectedItems)
                state.memory.photosData = state.memory.photos.map { $0.compressedImage }
                return .none
            case .binding:
                return .none
            case .setType(let type):
                state.memory.type = type
                return .none
            case .saveMemory(let memory):
                guard !state.isDisabled else { return .none }
                let isFirst = state.memory.isFirst
                return .run { send in
                    let _ = await TaskResult {
                        try isFirst ? self.memoryContext.add(memory) : self.memoryContext.edit(memory)
                    }
                    await send(.saveMemoryResponse)
                }
            case .saveMemoryResponse:
                return .send(.dismiss)
            case .checkDisabled:
                state.isDisabled = state.memory.photos.isEmpty || state.memory.title == "" || state.memory.note == ""
                return .none
            case .dismiss:
                return .run { _ in await self.dismiss() }
            }
        }
    }
}

// MARK: Photo
extension EditMemoryStore {
    func setPhotos(items: [PhotosPickerItem]) -> ([UIImage], Date, LocationModel?) {
        var photoDataArray: [UIImage] = []
        var dateArray: [Date] = []
        var locationArray: [LocationModel] = []
        
        let dispatchGroup = DispatchGroup()
        
        for item in items {
            dispatchGroup.enter()
            
            item.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let data):
                    if let data = data {
                        if let originalImage = UIImage(data: data) {
                            photoDataArray.append(originalImage)
                        }
                    }
                case .failure(let error):
                    print("Error loading transferable data: \(error)")
                }
                dispatchGroup.leave()
            }
            
            if let localID = item.itemIdentifier {
                dispatchGroup.enter()
                let result = PHAsset.fetchAssets(withLocalIdentifiers: [localID], options: nil)
                
                if let asset = result.firstObject {
                    if let date = asset.creationDate {
                        dateArray.append(date)
                    }
                    
                    if let location = asset.location?.coordinate {
                        let locationModel = LocationModel(
                            lat: location.latitude,
                            lon: location.longitude
                        )
                        locationArray.append(locationModel)
                    }
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.wait()  // 메인 스레드를 차단하고 모든 작업이 완료될 때까지 기다립니다.
        
        return (photoDataArray, dateArray.first ?? .now, locationArray.first)
    }
}
