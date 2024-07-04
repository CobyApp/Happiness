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
import ComposableArchitecture

struct EditMemoryView: View {
    
    @Bindable private var store: StoreOf<EditMemoryStore>
    
    init(store: StoreOf<EditMemoryStore>) {
        self.store = store
    }
    
    var isDisabled: Bool {
        self.store.memory.photos.isEmpty || self.store.memory.title == "" || self.store.memory.note == ""
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(
                leftSide: .left,
                leftAction: {
                    self.store.send(.dismiss)
                },
                title: "추억 기록"
            )
            
            ScrollView {
                VStack(spacing: 20) {
                    self.MemoryTypeView()
                    
                    self.PhotosView()
                    
                    self.ContentView()
                }
                .padding(.bottom, 20)
            }
            
            Button {
                if !self.isDisabled {
                    self.store.send(.saveMemory(self.store.memory))
                }
            } label: {
                Text("추억 만들기")
            }
            .buttonStyle(
                CBButtonStyle(
                    isDisabled: self.isDisabled,
                    isBlur: true,
                    buttonColor: Color.redNormal
                )
            )
            .padding(.horizontal, BaseSize.horizantalPadding)
            .padding(.bottom, 20)
        }
        .background(Color.backgroundNormalNormal)
        .onTapGesture {
            self.closeKeyboard()
        }
    }
    
    @ViewBuilder
    func MemoryTypeView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("태그")
                    .font(.pretendard(size: 16, weight: .regular))
                    .foregroundColor(Color.labelNormal)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, minHeight: 32)
            
            FlexibleStack(spacing: 8) {
                ForEach(MemoryType.allCases) { memoryType in
                    Text(memoryType.title)
                        .font(.pretendard(size: 14, weight: .regular))
                        .foregroundColor(Color.labelNeutral)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(self.store.memory.type == memoryType ? Color.fillStrong : Color.backgroundNormalNormal)
                        .clipShape(.rect(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.lineNormalNeutral, lineWidth: 1)
                        )
                        .onTapGesture {
                            self.store.send(.setType(memoryType))
                        }
                }
            }
        }
        .padding(.horizontal, BaseSize.horizantalPadding)
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
                        selection: self.$store.selectedItems,
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
                    
                    ForEach(self.store.memory.photos, id: \.self) { image in
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
                text: self.$store.memory.title,
                title: "제목",
                placeholder: "제목을 입력해주세요."
            )
            
            CBTextAreaView(
                text: self.$store.memory.note,
                title: "내용",
                placeholder: "내용을 입력해주세요."
            )
        }
        .padding(.horizontal, BaseSize.horizantalPadding)
    }
}
