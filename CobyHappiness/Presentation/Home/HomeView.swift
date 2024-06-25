//
//  HomeView.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 10/3/23.
//

import SwiftUI
import SwiftData

import CobyDS

struct HomeView: View {
    
    @EnvironmentObject private var appModel: AppViewModel
    
    @StateObject private var viewModel: HomeViewModel
    
    @State private var isPresented: Bool = false
    
    init(viewModel: HomeViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            self.HomeTopBarView()
            
            self.MemoryListView()
        }
        .background(Color.backgroundNormalNormal)
        .fullScreenCover(
            isPresented: self.$isPresented,
            onDismiss: {
                self.viewModel.getMemories()
            }
        ) {
            EditMemoryPageView()
        }
    }
    
    @ViewBuilder
    private func HomeTopBarView() -> some View {
        TopBarView(
            leftSide: .none,
            rightSide: .text,
            rightTitle: "추억 추가",
            rightAction: {
                self.isPresented = true
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
        if self.viewModel.memories.isEmpty {
            EmptyMemoryView {
                self.isPresented = true
            }
        } else {
            ScrollView {
                LazyVStack(spacing: BaseSize.cellVerticalSpacing) {
                    ForEach(self.viewModel.memories) { memory in
                        self.MemoryThumbnailView(for: memory)
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 20)
            }
        }
    }
    
    @ViewBuilder
    private func MemoryThumbnailView(for memory: MemoryModel) -> some View {
        ThumbnailCardView(
            image: memory.photos.first?.image,
            title: memory.title,
            description: memory.date.format("MMM d, yyyy"),
            isShadowing: true
        )
        .frame(width: BaseSize.fullWidth, height: BaseSize.fullWidth * 0.8)
        .frame(maxWidth: .infinity)
        .onTapGesture {
            self.appModel.currentActiveItem = memory
            self.appModel.showDetailView = true
        }
    }
}
