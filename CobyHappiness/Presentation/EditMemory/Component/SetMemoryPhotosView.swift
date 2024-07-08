//
//  SetMemoryPhotosView.swift
//  CobyHappiness
//
//  Created by Coby on 7/6/24.
//

import SwiftUI
import MapKit
import PhotosUI

import CobyDS

struct SetMemoryPhotosView: View {
    
    @Binding private var photosData: [Data]
    @Binding private var date: Date
    @Binding private var location: LocationModel?
    
    @State private var selectedItems: [PhotosPickerItem] = []
    
    private let title: String
    
    init(
        photosData: Binding<[Data]>,
        date: Binding<Date>,
        location: Binding<LocationModel?>,
        title: String
    ) {
        self._photosData = photosData
        self._date = date
        self._location = location
        self.title = title
    }
    
    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Text(self.title)
                    .font(.pretendard(size: 16, weight: .regular))
                    .foregroundColor(Color.labelNormal)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, minHeight: 32)
            .padding(.horizontal, BaseSize.horizantalPadding)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    PhotosPicker(
                        selection: self.$selectedItems,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        Image(uiImage: UIImage.icCamera)
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(Color.labelAlternative)
                            .frame(width: 80, height: 80)
                            .background(Color.fillStrong)
                            .clipShape(.rect(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.lineNormalNeutral, lineWidth: 1)
                            )
                    }
                    
                    ForEach(self.photosData, id: \.self) { imageData in
                        ThumbnailView(
                            image: UIImage(data: imageData)
                        )
                        .frame(width: 80, height: 80)
                    }
                }
                .padding(.horizontal, BaseSize.horizantalPadding)
            }
        }
        .onChange(of: self.selectedItems) {
            self.setPhotos(items: self.selectedItems) { data, date, location in
                self.photosData = data
                self.date = date
                self.location = location
            }
        }
    }
}

// MARK: Photo
extension SetMemoryPhotosView {
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
                        if let compressedData = UIImage(data: data)?.compressedImage {
                            photoDataArray.append(compressedData)
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
}
