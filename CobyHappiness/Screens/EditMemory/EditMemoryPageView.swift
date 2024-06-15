//
//  EditMemoryPageView.swift
//  CobyHappiness
//
//  Created by Coby on 6/11/24.
//

import SwiftUI
import MapKit

import CobyDS

struct EditMemoryPageView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var selection = 0
    @State private var date: Date = Date.now
    @State private var location: Location? = nil
    @State private var photos: [Data] = []

    var body: some View {
        TabView(selection: self.$selection) {
            ImagePickerView(
                didFinishPicking: { imagesWithMetadata in
                    self.photos = imagesWithMetadata.compactMap { self.compressImage($0.0) }
                    self.date = imagesWithMetadata.map { $0.1 ?? .now }.first ?? .now
                    self.location = imagesWithMetadata.map {
                        if let coordinate = $0.2?.coordinate {
                            Location(lat: coordinate.latitude, lon: coordinate.longitude)
                        } else {
                            nil
                        }
                    }.first ?? nil
                    
                    self.selection = 1
                },
                didCancel: {
                    self.dismiss()
                }
            )
            .edgesIgnoringSafeArea(.all)
            .tag(0)

            EditMemoryView(
                selection: $selection,
                memory: Memory(
                    date: self.date,
                    location: self.location,
                    photos: self.photos
                )
            )
            .tag(1)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .background(Color.backgroundNormalNormal)
    }
}

extension EditMemoryPageView {
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

#Preview {
    EditMemoryPageView()
}