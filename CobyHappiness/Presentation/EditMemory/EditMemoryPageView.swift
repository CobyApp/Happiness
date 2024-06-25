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
    
    @State private var selection: Int = 0
    @State private var memory: MemoryModel = MemoryModel()
    
    var body: some View {
        TabView(selection: self.$selection) {
            ImagePickerView(
                didFinishPicking: { imagesWithMetadata in
                    self.didFinishPicking(imagesWithMetadata)
                },
                didCancel: {
                    self.dismiss()
                }
            )
            .edgesIgnoringSafeArea(.all)
            .tag(0)

            EditMemoryContentView(
                viewModel: EditMemoryViewModel(),
                selection: $selection,
                memory: self.$memory
            )
            .tag(1)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .background(Color.backgroundNormalNormal)
    }
}

extension EditMemoryPageView {
    private func didFinishPicking(_ imagesWithMetadata: [(UIImage, Date?, CLLocation?)]) {
        self.memory.photos = imagesWithMetadata.compactMap { self.compressImage($0.0) }
        self.memory.date = imagesWithMetadata.map { $0.1 ?? .now }.first ?? .now
        self.memory.location = imagesWithMetadata.map {
            if let coordinate = $0.2?.coordinate {
                LocationModel(lat: coordinate.latitude, lon: coordinate.longitude)
            } else {
                nil
            }
        }.first ?? nil
        
        self.selection = 1
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

#Preview {
    EditMemoryPageView()
}
