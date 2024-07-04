//
//  MapView.swift
//  CobyHappiness
//
//  Created by Coby on 6/9/24.
//

import SwiftUI

import CobyDS
import ComposableArchitecture

struct MapView: View {
    
    @Bindable private var store: StoreOf<MapStore>
    
    init(store: StoreOf<MapStore>) {
        self.store = store
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(
                leftSide: .title,
                leftTitle: "지도",
                rightSide: .text,
                rightTitle: "추억 추가",
                rightAction: {
                    self.store.send(.showAddMemory)
                }
            )
            
            ZStack(alignment: .bottom) {
                MapRepresentableView(
                    memories: self.$store.memories,
                    topLeft: self.$store.topLeft,
                    bottomRight: self.$store.bottomRight
                )
                
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 8) {
                        ForEach(self.store.filteredMemories, id: \.self) { memory in
                            MemoryTileView(
                                memory: memory,
                                isShadowing: true
                            )
                            .frame(width: BaseSize.fullWidth, height: 100)
                            .padding(.horizontal, 20)
                            .containerRelativeFrame(.horizontal)
                            .onTapGesture {
                                self.store.send(.showDetailMemory(memory))
                            }
                        }
                    }
                    .scrollTargetLayout()
                }
                .contentMargins(.horizontal, BaseSize.horizantalPadding, for: .scrollContent)
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.viewAligned)
                .frame(height: 100)
                .padding(.bottom, 30)
            }
        }
        .background(Color.backgroundNormalNormal)
        .onAppear {
            self.store.send(.getMemories)
        }
        .navigationDestination(
            item: self.$store.scope(state: \.addMemory, action: \.addMemory)
        ) { store in
            EditMemoryView(store: store).navigationBarHidden(true)
        }
        .navigationDestination(
            item: self.$store.scope(state: \.detailMemory, action: \.detailMemory)
        ) { store in
            DetailMemoryView(store: store).navigationBarHidden(true)
        }
    }
}
