//
//  EditMemoryView.swift
//  CobyHappiness
//
//  Created by Coby on 6/11/24.
//

import SwiftUI
import MapKit
import PhotosUI

import CobyDS

struct EditMemoryView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel: EditMemoryViewModel
    
    @State private var isDisabled: Bool = true
    @State private var memory: MemoryModel
    @State private var selectedItems: [PhotosPickerItem] = []
    
    init(
        viewModel: EditMemoryViewModel
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.memory = MemoryModel()
    }
    
    init(
        viewModel: EditMemoryViewModel,
        memory: MemoryModel
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._memory = State(wrappedValue: memory)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(
                leftSide: .left,
                leftAction: {
                    self.dismiss()
                },
                title: "추억 기록"
            )
            
            ScrollView {
                VStack(spacing: 20) {
                    self.PhotosView()
                    
                    self.ContentView()
                }
            }
            
            Button {
                if !self.isDisabled {
                    self.viewModel.appendMemory(memory: self.memory)
                    self.dismiss()
                }
            } label: {
                Text("추억 만들기")
            }
            .buttonStyle(
                CBButtonStyle(
                    buttonColor: Color.redNormal,
                    disable: self.isDisabled
                )
            )
            .padding(.horizontal, BaseSize.horizantalPadding)
            .padding(.bottom, 20)
        }
        .background(Color.backgroundNormalNormal)
        .onTapGesture {
            self.closeKeyboard()
        }
        .onAppear {
            self.checkDisabled()
        }
        .onChange(of: [self.memory.title, self.memory.note]) {
            self.checkDisabled()
        }
    }
    
    @ViewBuilder
    func PhotosView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("사진")
                    .font(.pretendard(size: 16, weight: .regular))
                    .foregroundColor(Color.labelNormal)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, minHeight: 32)
            .padding(.horizontal, BaseSize.horizantalPadding)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    PhotosPicker(
                        selection: self.$selectedItems,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        Image(uiImage: UIImage.camera)
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(Color.labelAlternative)
                            .frame(width: 80, height: 80)
                            .background(Color.backgroundNormalAlternative)
                            .clipShape(.rect(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.lineNormalNeutral, lineWidth: 1)
                            )
                    }
                    .onChange(of: self.selectedItems) {
                        self.setPhotos()
                    }
                    
                    ForEach(self.memory.photos.compactMap { UIImage(data: $0) }, id: \.self) { image in
                        ThumbnailView(image: image)
                            .frame(width: 80, height: 80)
                    }
                }
                .padding(.horizontal, BaseSize.horizantalPadding)
            }
        }
    }
    
    @ViewBuilder
    func ContentView() -> some View {
        VStack(spacing: 20) {
            CBTextFieldView(
                text: self.$memory.title,
                title: "제목",
                placeholder: "제목을 입력해주세요."
            )
            
            CBTextAreaView(
                text: self.$memory.note,
                title: "내용",
                placeholder: "내용을 입력해주세요."
            )
        }
        .padding(.horizontal, BaseSize.horizantalPadding)
    }
}
 
extension EditMemoryView {
    private func checkDisabled() {
        if self.memory.photos.isEmpty || self.memory.title == "" || self.memory.note == "" {
            self.isDisabled = true
        } else {
            self.isDisabled = false
        }
    }
}
 
// MARK: Photo
extension EditMemoryView {
    private func setPhotos() {
        Task {
            self.memory.photos = []
            
            for item in selectedItems {
                if let data = try? await item.loadTransferable(type: Data.self) {
                    if let originalImage = UIImage(data: data) {
                        if let compressedImageData = compressImage(originalImage) {
                            self.memory.photos.append(compressedImageData)
                        }
                    }
                }
                
                if let localID = item.itemIdentifier {
                    let result = PHAsset.fetchAssets(withLocalIdentifiers: [localID], options: nil)
                    
                    if let asset = result.firstObject {
                        if let date = asset.creationDate {
                            self.memory.date = date
                        }
                            
                        if let location = asset.location?.coordinate {
                            self.memory.location = LocationModel(
                                lat: location.latitude,
                                lon: location.longitude
                            )
                        }
                    }
                }
            }
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
