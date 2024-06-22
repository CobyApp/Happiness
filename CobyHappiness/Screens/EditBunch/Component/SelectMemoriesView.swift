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
    @Binding var bunch: Bunch
    
    private let memories: [Memory]
    
    init(
        selection: Binding<Int>,
        bunch: Binding<Bunch>,
        memories: [Memory]
    ) {
        self._selection = selection
        self._bunch = bunch
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
                            isSelected: self.bunch.memories.contains(memory)
                        )
                        .onTapGesture {
                            if self.bunch.memories.contains(memory) {
                                self.bunch.memories = self.bunch.memories.filter { $0 != memory }
                            } else {
                                self.bunch.memories.append(memory)
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
