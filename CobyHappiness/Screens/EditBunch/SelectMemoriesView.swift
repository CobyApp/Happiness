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
    @Environment(\.modelContext) private var context
    
    @Query(sort: \Memory.date, order: .reverse)
    private var memories: [Memory]
    
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
            
            Button {
                self.storeBunch()
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

extension SelectMemoriesView {
    private func storeBunch() {
        do {
            let item = Bunch(
                date: self.selectedMemories.first?.date ?? Date.now,
                title: self.selectedMemories.first?.title ?? "제목",
                note: self.selectedMemories.first?.note ?? "내용",
                memories: []
            )
            item.memories = self.selectedMemories
            self.context.insert(item)
            try self.context.save()
            
            self.dismiss()
        } catch {
            print("error")
        }
    }
}

#Preview {
    SelectMemoriesView()
}
