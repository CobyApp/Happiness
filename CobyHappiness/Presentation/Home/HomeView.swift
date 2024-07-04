//
//  HomeView.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 10/3/23.
//

import SwiftUI

import CobyDS
import ComposableArchitecture

struct HomeView: View {

    @Bindable private var store: StoreOf<HomeStore>
    
    init(store: StoreOf<HomeStore>) {
        self.store = store
    }
    
    var body: some View {
        VStack(spacing: 0) {
            self.HomeTopBarView()
            
            self.MemoryListView()
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
    
    @ViewBuilder
    private func HomeTopBarView() -> some View {
        TopBarView(
            leftSide: .none,
            rightSide: .text,
            rightTitle: "추억 추가",
            rightAction: {
                self.store.send(.showAddMemory)
            }
        )
        .overlay(alignment: .leading) {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(height: 40)
                .foregroundColor(Color.labelNormal)
                .padding(.top, 4)
                .padding(.leading, 20)
        }
    }
    
    @ViewBuilder
    private func MemoryListView() -> some View {
        if self.store.memories.isEmpty {
            EmptyMemoryView {
                self.store.send(.showAddMemory)
            }
        } else {
            ScrollView {
                LazyVStack(spacing: BaseSize.cellVerticalSpacing) {
                    ForEach(self.store.memories) { memory in
                        MemoryThumbnailView(
                            memory: memory
                        )
                        .onTapGesture {
                            self.store.send(.showDetailMemory(memory))
                        }
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 20)
            }
        }
    }
    
    @ViewBuilder
    private func MemoryThumbnailView(memory: MemoryModel) -> some View {
        ThumbnailCardView(
            image: memory.photos.first,
            title: memory.title,
            description: memory.date.format("yyyy년 MM월 dd일"),
            isShadowing: true
        )
        .frame(width: BaseSize.fullWidth, height: BaseSize.fullWidth * 0.8)
        .frame(maxWidth: .infinity)
    }
}
