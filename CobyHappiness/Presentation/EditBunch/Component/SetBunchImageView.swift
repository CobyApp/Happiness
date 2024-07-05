//
//  SetBunchImageView.swift
//  CobyHappiness
//
//  Created by Coby on 7/6/24.
//

import SwiftUI
import PhotosUI

import CobyDS

struct SetBunchImageView: View {
    
    @Binding private var image: UIImage?
    
    @State private var selectedItem: PhotosPickerItem?
    
    init(
        image: Binding<UIImage?>
    ) {
        self._image = image
    }
    
    var body: some View {
        PhotosPicker(
            selection: self.$selectedItem,
            matching: .images,
            photoLibrary: .shared()
        ) {
            ThumbnailView(
                image: self.image
            )
            .frame(width: 100, height: 100)
        }
        .onChange(of: self.selectedItem, self.loadImage)
    }
    
    func loadImage() {
        Task {
            guard let imageData = try await self.selectedItem?.loadTransferable(type: Data.self) else { return }
            guard let inputImage = UIImage(data: imageData) else { return }
            self.image = inputImage
        }
    }
}
