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
    
    @State private var selectedItems: [PhotosPickerItem] = []
    
    @State private var type: MemoryType = MemoryType.moment
    @State private var date: Date = Date()
    @State private var title: String = ""
    @State private var note: String = ""
    @State private var location: LocationModel? = nil
    @State private var photos: [Data] = []
    
    var isDisabled: Bool {
        self.photos.isEmpty || self.title == "" || self.note == ""
    }
    
    init(
        viewModel: EditMemoryViewModel
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
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
                    self.viewModel.appendMemory(
                        type: self.type,
                        date: self.date,
                        title: self.title,
                        note: self.note,
                        location: self.location,
                        photos: self.photos
                    )
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
            if let memory = self.viewModel.getMemory() {
                self.type = memory.type
                self.title = memory.title
                self.note = memory.note
                self.photos = memory.photos
            }
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
                        self.viewModel.setPhotos(items: self.selectedItems) { photos, date, location in
                            self.photos = photos
                            self.date = date
                            self.location = location
                        }
                    }
                    
                    ForEach(self.photos.compactMap { UIImage(data: $0) }, id: \.self) { image in
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
                text: self.$title,
                title: "제목",
                placeholder: "제목을 입력해주세요."
            )
            
            CBTextAreaView(
                text: self.$note,
                title: "내용",
                placeholder: "내용을 입력해주세요."
            )
        }
        .padding(.horizontal, BaseSize.horizantalPadding)
    }
}
