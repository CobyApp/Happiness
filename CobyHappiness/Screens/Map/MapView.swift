//
//  MapView.swift
//  CobyHappiness
//
//  Created by Coby on 6/9/24.
//

import SwiftUI
import SwiftData
import MapKit

import CobyDS

struct MapView: View {
    
    @Query
    private var memories: [Memory]
    
    @State private var isPresented: Bool = false
    @State private var memory: Memory? = nil
    @State private var topLeft: CLLocationCoordinate2D = .init()
    @State private var bottomRight: CLLocationCoordinate2D = .init()
    
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
                    topLeft: self.$topLeft,
                    bottomRight: self.$bottomRight,
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
