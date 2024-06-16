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
    
    @Binding var selection: Int
    @Binding var memories: [Memory]
    @Binding var selectedMemories: [Memory]
    
    var body: some View {
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
