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

struct EditMemoryStore: Reducer {
    
    @ObservableState
    struct State: Equatable {
        var isPresented: Bool = true
        var memory: MemoryModel
        
        init(
            memory: MemoryModel = MemoryModel()
        ) {
            self.memory = memory
        }
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case setPhotos([PhotosPickerItem])
        case saveMemory(MemoryModel)
        case saveMemoryResponse
        case dismiss
    }
    
    @Dependency(\.memoryData) private var memoryContext
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .setPhotos(let photoItems):
                (state.memory.photos, state.memory.date, state.memory.location) = self.setPhotos(items: photoItems)
                return .none
            case .saveMemory(let memory):
                return .run { send in
                    let _ = await TaskResult {
                        try self.memoryContext.add(memory)
                    }
                    await send(.saveMemoryResponse)
                }
            case .saveMemoryResponse:
                return .send(.dismiss)
            case .dismiss:
                state.isPresented = false
                return .none
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
