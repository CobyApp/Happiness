//
//  EditBunchView.swift
//  CobyHappiness
//
//  Created by Coby on 6/16/24.
//

import SwiftUI

import CobyDS
import ComposableArchitecture

struct EditBunchView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Bindable private var store: StoreOf<EditBunchStore>
    
    init(store: StoreOf<EditBunchStore>) {
        self.store = store
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(
                leftSide: .left,
                leftAction: {
                    self.store.send(.dismiss)
                },
                title: "추억 선택"
            )
            
            SelectMemoriesView(
                selectedMemories: self.$store.bunch.memories,
                memories: self.store.memories
            )
            
            Button {
                self.store.send(.showTitleAlert)
            } label: {
                Text("뭉치 만들기")
            }
            .buttonStyle(
                CBButtonStyle(
                    buttonColor: Color.redNormal,
                    disable: self.store.bunch.memories.isEmpty
                )
            )
            .padding(.horizontal, BaseSize.horizantalPadding)
            .padding(.bottom, 20)
        }
        .background(Color.backgroundNormalNormal)
        .onAppear {
            self.store.send(.getMemories)
        }
        .onChange(of: self.store.isPresented) {
            self.dismiss()
        }
        .alert("뭉치 만들기", isPresented: self.$store.showingAlert) {
            TextField(self.store.bunch.title, text: self.$store.bunch.title)
            
            Button("확인", action: {
                self.store.send(.saveBunch(self.store.bunch))
            })
        } message: {
            Text("뭉치 이름을 입력해주세요")
        }
    }
}
