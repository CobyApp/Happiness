//
//  SelectMemorysView.swift
//  CobyHappiness
//
//  Created by Coby on 6/12/24.
//

import SwiftUI
import SwiftData

import CobyDS

struct SelectMemorysView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @Query(sort: \Memory.date, order: .reverse)
    private var memorys: [Memory]
    
    @State private var selectedMemorys: [Memory] = []
    
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
                    ForEach(self.memorys) { memory in
                        MemoryTileView(
                            memory: memory,
                            isSelected: self.selectedMemorys.contains(memory)
                        )
                        .onTapGesture {
                            if self.selectedMemorys.contains(memory) {
                                self.selectedMemorys = self.selectedMemorys.filter { $0 != memory }
                            } else {
                                self.selectedMemorys.append(memory)
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
                    disable: self.selectedMemorys.isEmpty
                )
            )
            .padding(.horizontal, BaseSize.horizantalPadding)
        }
    }
}

extension SelectMemorysView {
    private func storeBunch() {
        do {
            let item = Bunch(
                date: self.selectedMemorys.first?.date ?? Date.now,
                title: self.selectedMemorys.first?.title ?? "제목",
                note: self.selectedMemorys.first?.note ?? "내용",
                memorys: self.selectedMemorys
            )
            self.context.insert(item)
            try self.context.save()
            self.dismiss()
        } catch {
            print("error")
        }
    }
}

#Preview {
    SelectMemorysView()
}
