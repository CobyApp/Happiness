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

    private let store: StoreOf<HomeStore>
    
    init(store: StoreOf<HomeStore>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 0) {
                self.HomeTopBarView(viewStore: viewStore)
                
                self.MemoryListView(viewStore: viewStore)
            }
            .background(Color.backgroundNormalNormal)
            .fullScreenCover(
                isPresented: viewStore.$showingEditMemoryView,
                onDismiss: {
                    viewStore.send(.getMemories)
                }
            ) {
                EditMemoryView(viewModel: EditMemoryViewModel())
            }
            .onAppear {
                viewStore.send(.onAppear(self.appModel))
            }
        }
    }
    
    @ViewBuilder
    private func HomeTopBarView(viewStore: ViewStore<HomeStore.State, HomeStore.Action>) -> some View {
        TopBarView(
            leftSide: .none,
            rightSide: .text,
            rightTitle: "추억 추가",
            rightAction: {
                viewStore.send(.showEditMemory)
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
    private func MemoryListView(viewStore: ViewStore<HomeStore.State, HomeStore.Action>) -> some View {
        if viewStore.memories.isEmpty {
            EmptyMemoryView {
                viewStore.send(.showEditMemory)
            }
        } else {
            ScrollView {
                LazyVStack(spacing: BaseSize.cellVerticalSpacing) {
                    ForEach(viewStore.memories) { memory in
                        self.MemoryThumbnailView(
                            memory: memory
                        )
                        .onTapGesture {
                            viewStore.send(.showMemoryDetail(memory))
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
