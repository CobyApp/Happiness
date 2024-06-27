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
    
    @EnvironmentObject private var appModel: AppViewModel

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
        .fullScreenCover(
            isPresented: self.$store.showingEditMemoryView,
            onDismiss: {
                self.store.send(.getMemories)
            }
        ) {
            EditMemoryView(viewModel: EditMemoryViewModel())
        }
        .onAppear {
            self.store.send(.onAppear(self.appModel))
        }
    }
    
    @ViewBuilder
    private func HomeTopBarView() -> some View {
        TopBarView(
            leftSide: .none,
            rightSide: .text,
            rightTitle: "추억 추가",
            rightAction: {
                self.store.send(.showEditMemory)
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
                self.store.send(.showEditMemory)
            }
        } else {
            ScrollView {
                LazyVStack(spacing: BaseSize.cellVerticalSpacing) {
                    ForEach(self.store.memories) { memory in
                        self.MemoryThumbnailView(
                            memory: memory
                        )
                        .onTapGesture {
                            self.store.send(.showMemoryDetail(memory))
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
            image: memory.photos.first?.image,
            title: memory.title,
            description: memory.date.format("MMM d, yyyy"),
            isShadowing: true
        )
        .frame(width: BaseSize.fullWidth, height: BaseSize.fullWidth * 0.8)
        .frame(maxWidth: .infinity)
    }
}
