//
//  EditBunchPageView.swift
//  CobyHappiness
//
//  Created by Coby on 6/16/24.
//

import SwiftUI
import SwiftData

import CobyDS

struct EditBunchPageView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var showAlert = false
    @State private var bunch: BunchModel
    
    @State private var viewModel: EditBunchViewModel = EditBunchViewModel()
    
    init(
        bunch: BunchModel = BunchModel()
    ) {
        self._bunch = State(wrappedValue: bunch)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(
                leftSide: .left,
                leftAction: {
                    self.dismiss()
                },
                title: "추억 선택"
            )
            
            SelectMemoriesView(
                selectedMemories: self.$bunch.memories,
                memories: self.viewModel.memories
            )
            
            Button {
                if !self.bunch.memories.isEmpty {
                    self.bunch.startDate = self.bunch.memories.map { $0.date }.min() ?? .now
                    self.bunch.endDate = self.bunch.memories.map { $0.date }.max() ?? .now
                    self.showAlert = true
                }
            } label: {
                Text("뭉치 만들기")
            }
            .buttonStyle(
                CBButtonStyle(
                    buttonColor: Color.redNormal,
                    disable: self.bunch.memories.isEmpty
                )
            )
            .padding(.horizontal, BaseSize.horizantalPadding)
            .padding(.bottom, 20)
        }
        .background(Color.backgroundNormalNormal)
        .alert("뭉치 만들기", isPresented: self.$showAlert) {
            TextField(self.bunch.title, text: self.$bunch.title)
            Button("확인", action: {
                self.viewModel.saveBunch(bunch: self.bunch)
                self.dismiss()
            })
        } message: {
            Text("뭉치 이름을 입력해주세요")
        }
    }
}
