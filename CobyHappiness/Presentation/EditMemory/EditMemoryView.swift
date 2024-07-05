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
                    
                    SelectPhotosView(
                        selectedItems: self.$store.selectedItems,
                        images: self.store.memory.photos
                    )
                    
                    self.ContentView()
                }
                .padding(.bottom, 20)
            }
            
            Button {
                self.store.send(.saveMemory(self.store.memory))
            } label: {
                Text("추억 만들기")
            }
            .buttonStyle(
                CBButtonStyle(
                    isDisabled: self.store.isDisabled,
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
        .onAppear {
            self.store.send(.checkDisabled)
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
                    TagView(
                        isSelected: self.store.memory.type == memoryType,
                        title: memoryType.title
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
