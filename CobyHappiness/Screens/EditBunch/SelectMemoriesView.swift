//
//  SelectMemoriesView.swift
//  CobyHappiness
//
//  Created by Coby on 6/12/24.
//

import SwiftUI
import SwiftData

import CobyDS

struct SelectMemoriesView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewModel: EditBunchViewModel = EditBunchViewModel()
    @State private var selectedMemories: [Memory] = []
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(
                leftSide: .left,
                leftAction: {
                    self.dismiss()
                },
                title: "추억 선택하기"
            )
            
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(self.viewModel.memories) { memory in
                        MemoryTileView(
                            memory: memory,
                            isSelected: self.selectedMemories.contains(memory)
                        )
                        .onTapGesture {
                            if self.selectedMemories.contains(memory) {
                                self.selectedMemories = self.selectedMemories.filter { $0 != memory }
                            } else {
                                self.selectedMemories.append(memory)
                            }
                        }
                    }
                }
                .padding(.horizontal, BaseSize.horizantalPadding)
                .padding(.top, 8)
                .padding(.bottom, 20)
            }
            
            Button {
                self.viewModel.appendBunch(selectedMemories: self.selectedMemories)
                self.dismiss()
            } label: {
                Text("저장")
            }
            .buttonStyle(
                CBButtonStyle(
                    buttonColor: Color.redNormal,
                    disable: self.selectedMemories.isEmpty
                )
            )
            .padding(.horizontal, BaseSize.horizantalPadding)
        }
    }
}

#Preview {
    SelectMemoriesView()
}
