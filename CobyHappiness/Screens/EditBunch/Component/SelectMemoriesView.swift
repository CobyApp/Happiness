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
    
    @Binding var selectedMemories: [Memory]
    
    private let memories: [Memory]
    
    init(
        selectedMemories: Binding<[Memory]>,
        memories: [Memory]
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
            ScrollView {
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
                .padding(.horizontal, BaseSize.horizantalPadding)
                .padding(.top, 8)
                .padding(.bottom, 20)
            }
        }
    }
}
