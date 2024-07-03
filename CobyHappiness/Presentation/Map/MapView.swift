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
                    self.store.send(.showEditMemory)
                }
            )
            
            ZStack(alignment: .bottom) {
                MapRepresentableView(
                    memories: self.$store.memories,
                    filteredMemories: self.$store.filteredMemories
                )
                
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 8) {
                        ForEach(self.store.filteredMemories, id: \.self) { memory in
                            NavigationLink(
                                state: RootStore.Path.State.detailMemory(MemoryDetailStore.State(memory: memory))
                            ) {
                                MemoryTileView(
                                    memory: memory,
                                    isShadowing: true
                                )
                                .frame(width: BaseSize.fullWidth, height: 100)
                                .padding(.horizontal, 20)
                                .containerRelativeFrame(.horizontal)
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
        .fullScreenCover(
            isPresented: self.$store.showingEditMemoryView,
            onDismiss: {
                self.store.send(.getMemories)
            }
        ) {
            EditMemoryView(store: Store(initialState: EditMemoryStore.State()) {
                EditMemoryStore()
            })
        }
        .onAppear {
            self.store.send(.getMemories)
        }
    }
}
