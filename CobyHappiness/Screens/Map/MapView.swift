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
    
    @EnvironmentObject private var appModel: AppViewModel
    @Environment(\.animationNamespace) var animation
    
    @State private var viewModel: MapViewModel = MapViewModel()
    @State private var isPresented: Bool = false
    @State private var filteredMemories: [Memory] = []
    
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
                        withAnimation(.spring()) {
                            self.appModel.currentActiveItem = memory
                            self.appModel.showDetailView = true
                        }
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
