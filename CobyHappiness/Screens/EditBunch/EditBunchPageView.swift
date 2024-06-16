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
    
    @State private var selection = 0
    @State private var selectedMemories: [Memory] = []
    @State private var bunch: Bunch = Bunch()
    
    @State private var viewModel: EditBunchViewModel = EditBunchViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(
                leftSide: .left,
                leftAction: {
                    self.dismiss()
                },
                title: self.selection == 0 ? "추억 선택하기" : "추억 뭉치 기록하기"
            )
            
            TabView(selection: self.$selection) {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(self.viewModel.memories) { memory in
                            MemoryTileView(
                                memory: memory,
                                isSelected: self.viewModel.selectedMemories.contains(memory)
                            )
                            .onTapGesture {
                                if self.viewModel.selectedMemories.contains(memory) {
                                    self.viewModel.selectedMemories = self.viewModel.selectedMemories.filter { $0 != memory }
                                } else {
                                    self.viewModel.selectedMemories.append(memory)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, BaseSize.horizantalPadding)
                    .padding(.top, 8)
                    .padding(.bottom, 20)
                }
                .tag(0)
                
                EditBunchContentView(
                    selection: self.$selection,
                    bunch: self.$bunch
                )
                .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .background(Color.backgroundNormalNormal)
            
            
            Button {
                if self.selection == 0 {
                    self.bunch.date = selectedMemories.first?.date ?? Date.now
                    self.bunch.title = selectedMemories.first?.title ?? ""
                    self.bunch.note = selectedMemories.first?.note ?? ""
                    self.bunch.memories = selectedMemories
                    self.selection = 1
                } else {
                    self.viewModel.appendBunch(bunch: self.bunch)
                    self.dismiss()
                }
            } label: {
                Text("저장")
            }
            .buttonStyle(
                CBButtonStyle(
                    buttonColor: Color.redNormal,
                    disable: self.viewModel.selectedMemories.isEmpty
                )
            )
            .padding(.horizontal, BaseSize.horizantalPadding)
        }
    }
}
