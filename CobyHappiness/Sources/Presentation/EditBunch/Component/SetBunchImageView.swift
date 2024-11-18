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
    @Binding private var imageData: Data?
    
    @State private var selectedItem: PhotosPickerItem?
    
    init(
        image: Binding<UIImage?>,
        imageData: Binding<Data?>
    ) {
        self._image = image
        self._imageData = imageData
    }
    
    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Text("추억들을 대표하는 사진을 골라주세요.")
                    .font(.pretendard(size: 16, weight: .regular))
                    .foregroundColor(Color.labelNormal)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, minHeight: 32)
            
            HStack {
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
                
                Spacer()
            }
        }
        .padding(.horizontal, BaseSize.horizantalPadding)
    }
    
    func loadImage() {
        Task {
            guard let imageData = try await self.selectedItem?.loadTransferable(type: Data.self) else { return }
            guard let inputImage = UIImage(data: imageData) else { return }
            self.image = inputImage
            self.imageData = imageData
        }
    }
}
