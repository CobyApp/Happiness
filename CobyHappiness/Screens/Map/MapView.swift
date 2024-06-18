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
    
    @State private var viewModel: MapViewModel = MapViewModel()
    @State private var isPresented: Bool = false
    @State private var memory: Memory? = nil
    @State private var filteredMemories: [Memory] = []
    
    private var animation: Namespace.ID
    
    init(
        animation: Namespace.ID
    ) {
        self.animation = animation
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(
                leftSide: .text,
                leftTitle: "지도",
                rightSide: .icon,
                rightIcon: UIImage.icPlus,
                rightAction: {
                    self.isPresented = true
                }
            )
            
            ZStack(alignment: .bottom) {
                MapRepresentableView(
                    filteredMemories: self.$filteredMemories,
                    memories: self.viewModel.memories
                )
                
                if let memory = self.filteredMemories.first {
                    MemoryTileView(
                        memory: memory,
                        isShadowing: true
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                    .onTapGesture {
                        self.memory = memory
                    }
                }
            }
        }
        .background(Color.backgroundNormalNormal)
        .fullScreenCover(
            isPresented: self.$isPresented,
            onDismiss: {
                self.viewModel.fetchMemories()
            }
        ) {
            EditMemoryPageView()
        }
    }
}
