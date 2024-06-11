//
//  BunchDetailView.swift
//  CobyHappiness
//
//  Created by Coby on 6/12/24.
//

import SwiftUI

import SwiftUI
import SwiftData

import CobyDS

struct BunchDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var showingSheet = false
    @State private var showingAlert = false
    @State private var isPresented: Bool = false
    @State private var memory: Memory? = nil
    
    private var bunch: Bunch
    
    init(
        bunch: Bunch
    ) {
        self.bunch = bunch
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(
                leftSide: .left,
                leftAction: {
                    self.dismiss()
                },
                rightSide: .icon,
                rightIcon: Image("more"),
                rightAction: {
                    self.showingSheet = true
                }
            )
            
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(self.bunch.memories) { memory in
                        MemoryTileView(
                            memory: memory
                        )
                        .onTapGesture {
                            self.memory = memory
                        }
                    }
                }
                .padding(.horizontal, BaseSize.horizantalPadding)
                .padding(.top, 8)
                .padding(.bottom, 20)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .actionSheet(isPresented: self.$showingSheet) {
            ActionSheet(
                title: Text("원하는 옵션을 선택해주세요."),
                message: nil,
                buttons: [
                    .default(Text("편집")) {
                        self.isPresented = true
                    },
                    .destructive(Text("삭제")) {
                        self.showingAlert = true
                    },
                    .cancel(Text("취소"))
                ]
            )
        }
        .alert(isPresented: self.$showingAlert) {
            Alert(
                title: Text("추억 뭉치를 삭제하시겠습니까?"),
                message: nil,
                primaryButton: .destructive(
                    Text("삭제"),
                    action: {
                        self.context.delete(self.bunch)
                        self.dismiss()
                    }
                ),
                secondaryButton: .cancel(Text("취소"))
            )
        }
        .fullScreenCover(item: self.$memory, onDismiss: { self.memory = nil }) { item in
            EventDetailView(memory: item)
        }
    }
}