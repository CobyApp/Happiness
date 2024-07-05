//
//  DetailBunchView.swift
//  CobyHappiness
//
//  Created by Coby on 6/12/24.
//

import SwiftUI

import CobyDS
import ComposableArchitecture

struct DetailBunchView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Bindable private var store: StoreOf<DetailBunchStore>
    
    init(store: StoreOf<DetailBunchStore>) {
        self.store = store
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(
                leftSide: .left,
                leftAction: {
                    self.store.send(.dismiss)
                },
                rightSide: .icon,
                rightIcon: UIImage.icMore,
                rightAction: {
                    self.store.send(.showOptionSheet)
                }
            )
            
            MemoryListView(memories: self.store.bunch.memories)
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color.backgroundNormalNormal)
        .navigationDestination(
            item: self.$store.scope(state: \.detailMemory, action: \.detailMemory)
        ) { store in
            DetailMemoryView(store: store).navigationBarHidden(true)
        }
        .navigationDestination(
            item: self.$store.scope(state: \.editBunch, action: \.editBunch)
        ) { store in
            EditBunchView(store: store).navigationBarHidden(true)
        }
        .confirmationDialog(
            self.$store.scope(state: \.optionSheet, action: \.optionSheet)
        )
        .alert(
            self.$store.scope(state: \.deleteAlert, action: \.deleteAlert)
        )
    }
    
    @ViewBuilder
    private func MemoryListView(memories: [MemoryModel]) -> some View {
        if memories.isEmpty {
            EmptyMemoryView(
                showingButton: false
            )
            .padding(.top, -100)
        } else {
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(memories) { memory in
                        MemoryTileView(
                            memory: memory
                        )
                    }
                }
                .padding(.horizontal, BaseSize.horizantalPadding)
                .padding(.top, 8)
                .padding(.bottom, 20)
            }
        }
    }
}
