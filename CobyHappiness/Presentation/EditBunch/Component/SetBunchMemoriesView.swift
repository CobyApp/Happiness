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
                    Text("뭉칠 일상들을 선택해주세요.")
                        .font(.pretendard(size: 16, weight: .regular))
                        .foregroundColor(Color.labelNormal)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, minHeight: 32)
                
                LazyVStack(spacing: 8) {
                    ForEach(self.memories) { memory in
                        ThumbnailTileView(
                            isSelected: self.selectedMemories.contains(where: { $0.id == memory.id }),
                            image: memory.photos.first,
                            title: memory.title,
                            subTitle: memory.date.formatShort,
                            description: memory.note,
                            isSelectedBorderColor: Color.redNormal
                        )
                        .frame(width: BaseSize.fullWidth, height: 120)
                        .onTapGesture {
                            if self.selectedMemories.contains(where: { $0.id == memory.id }) {
                                self.selectedMemories = self.selectedMemories.filter { $0.id != memory.id }
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
