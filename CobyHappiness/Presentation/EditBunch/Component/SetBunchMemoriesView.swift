//
//  SetBunchMemoriesView.swift
//  CobyHappiness
//
//  Created by Coby on 6/12/24.
//

import SwiftUI
import SwiftData

import CobyDS

struct SetBunchMemoriesView: View {
    
    @Binding var selectedMemories: [MemoryModel]
    
    private let memories: [MemoryModel]
    
    init(
        selectedMemories: Binding<[MemoryModel]>,
        memories: [MemoryModel]
    ) {
        self._selectedMemories = selectedMemories
        self.memories = memories
    }
    
    var body: some View {
        if self.memories.isEmpty {
            EmptyMemoryView(
                showingButton: false
            )
        } else {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("뭉칠 기록들을 선택해주세요.")
                        .font(.pretendard(size: 16, weight: .regular))
                        .foregroundColor(Color.labelNormal)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, minHeight: 32)
                
                LazyVStack(spacing: 8) {
                    ForEach(self.memories) { memory in
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
            }
            .padding(.horizontal, BaseSize.horizantalPadding)
        }
    }
}
