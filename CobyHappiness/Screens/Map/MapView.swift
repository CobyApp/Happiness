//
//  MapView.swift
//  CobyHappiness
//
//  Created by Coby on 6/9/24.
//

import SwiftUI
import SwiftData

import CobyDS

struct MapView: View {
    
    @Query
    private var memories: [Memory]
    
    @State private var isPresented: Bool = false
    @State private var memory: Memory? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(
                leftSide: .text,
                leftTitle: "지도",
                rightSide: .icon,
                rightIcon: Image("plus"),
                rightAction: {
                    self.isPresented = true
                }
            )
            
            ZStack(alignment: .bottom) {
                MapRepresentableView(
                    memories: self.memories
                )
                
                if let memory = self.memories.first {
                    MemoryTileView(
                        memory: memory,
                        isShadowing: true
                    )
                    .padding(20)
                    .onTapGesture {
                        self.memory = memory
                    }
                }
            }
        }
        .background(Color.backgroundNormalNormal)
        .fullScreenCover(isPresented: self.$isPresented) {
            EditView()
        }
        .fullScreenCover(item: self.$memory, onDismiss: { self.memory = nil }) { item in
            EventDetailView(memory: item)
        }
    }
}
