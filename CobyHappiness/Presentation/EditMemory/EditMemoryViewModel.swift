//
//  EditMemoryViewModel.swift
//  CobyHappiness
//
//  Created by Coby on 6/16/24.
//

import SwiftUI
import PhotosUI

final class EditMemoryViewModel: ObservableObject {
    
    @Published private(set) var isError: Bool = false
    @Published private(set) var errorMessage: String = ""
    
    private let usecase: AppUsecase
    private let memory: MemoryModel?
    
    init(
        usecase: AppUsecase = AppUsecase(AppRepositoryImpl()),
        memory: MemoryModel? = nil
    ) {
        self.usecase = usecase
        self.memory = memory
    }
    
    @MainActor
    func showErrorMessage(_ message: String) async {
        self.isError = true
        self.errorMessage = message
    }
    
    func getMemory() -> MemoryModel? {
        self.memory
    }
    
    func appendMemory(
        type: MemoryType,
        date: Date,
        title: String,
        note: String,
        location: LocationModel?,
        photos: [Data]
    ) {
        Task {
            do {
                if let memory = self.memory {
                    let item = MemoryModel(
                        id: memory.id,
                        date: date,
                        type: type,
                        title: title,
                        note: note,
                        location: location,
                        photos: photos,
                        bunches: memory.bunches
                    )
                    try self.usecase.saveMemory(memory: item)
                } else {
                    let item = MemoryModel(
                        date: date,
                        type: type,
                        title: title,
                        note: note,
                        location: location,
                        photos: photos
                    )
                    try self.usecase.saveMemory(memory: item)
                }
            } catch(let error) {
                await self.showErrorMessage(error.localizedDescription)
            }
        }
    }
}

// MARK: Photo
extension EditMemoryViewModel {
    func setPhotos(items: [PhotosPickerItem], completion: @escaping ([Data], Date, LocationModel?) -> Void) {
        var photoDataArray: [Data] = []
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
                            if let compressedImageData = self.compressImage(originalImage) {
                                photoDataArray.append(compressedImageData)
                            }
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
        
        dispatchGroup.notify(queue: .main) {
            completion(photoDataArray, dateArray.first ?? .now, locationArray.first)
        }
    }
    
    private func compressImage(_ image: UIImage) -> Data? {
        let newSize = CGSize(width: image.size.width * 0.3, height: image.size.height * 0.3)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let compressedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let compressedImageData = compressedImage?.jpegData(compressionQuality: 0.3) {
            return compressedImageData
        } else {
            return nil
        }
    }
}
