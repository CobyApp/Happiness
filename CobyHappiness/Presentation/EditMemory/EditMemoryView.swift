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
                    SetMemoryTypeView(
                        selectedType: self.$store.memory.type,
                        setTypeAction: { type in
                            self.store.send(.setType(type))
                        }
                    )
                    
                    SetMemoryPhotosView(
                        selectedItems: self.$store.selectedItems,
                        images: self.store.memory.photos
                    )
                    
                    SetMemoryContentView(
                        title: self.$store.memory.title,
                        note: self.$store.memory.note
                    )
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
}
