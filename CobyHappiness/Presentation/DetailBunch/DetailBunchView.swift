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
    
    @Bindable private var store: StoreOf<DetailBunchStore>
    
    init(store: StoreOf<DetailBunchStore>) {
        self.store = store
    }
    
    var body: some View {
        CBScaleScrollView(
            isPresented: self.$store.isPresented,
            scale: self.$store.scale,
            isDown: self.$store.isDown,
            header: {
                DetailHeaderView(
                    isDown: self.store.isDown,
                    backAction: { self.store.send(.dismiss) },
                    optionAction: { self.store.send(.showOptionSheet) }
                )
            },
            content: {
                VStack(spacing: 20) {
                    DetailPhotosView(photos: self.store.bunch.photos)
                    
                    ContentView(bunch: self.store.bunch)
                }
            }
        )
        .onAppear {
            self.store.send(.getBunch)
        }
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
    private func ContentView(bunch: BunchModel) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(bunch.title)
                    .font(.pretendard(size: 20, weight: .semibold))
                    .foregroundStyle(Color.labelNormal)
                
                Text(bunch.term)
                    .font(.pretendard(size: 14, weight: .regular))
                    .foregroundStyle(Color.labelAlternative)
            }
            
            CBDivider()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("목록")
                    .font(.pretendard(size: 16, weight: .semibold))
                    .foregroundColor(Color.labelNormal)
                
                MemoryListView(memories: bunch.memories)
            }
        }
        .padding(.horizontal, BaseSize.horizantalPadding)
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private func MemoryListView(memories: [MemoryModel]) -> some View {
        if memories.isEmpty {
            EmptyMemoryView(
                showingButton: false
            )
            .padding(.top, -100)
        } else {
            LazyVStack(spacing: 8) {
                ForEach(memories) { memory in
                    MemoryTileView(
                        memory: memory
                    )
                    .onTapGesture {
                        self.store.send(.showDetailMemory(memory))
                    }
                }
            }
        }
    }
}
