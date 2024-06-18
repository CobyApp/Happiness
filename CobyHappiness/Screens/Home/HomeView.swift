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
    
    @State private var viewModel: HomeViewModel = HomeViewModel()
    @State private var isPresented: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            self.HomeTopBarView()
            
            self.MemoryListView()
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
    
    @ViewBuilder
    private func HomeTopBarView() -> some View {
        TopBarView(
            leftSide: .none,
            rightSide: .icon,
            rightIcon: UIImage.icPlus,
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
    
    @ViewBuilder
    private func MemoryThumbnailView(for memory: Memory) -> some View {
        ThumbnailCardView(
            image: memory.photos.first?.image,
            title: memory.title,
            description: memory.date.format("MMM d, yyyy"),
            isShadowing: true
        )
        .frame(width: BaseSize.fullWidth, height: BaseSize.fullWidth * 0.8)
        .onTapGesture {
            withAnimation(.spring()) {
                self.appModel.currentActiveItem = memory
                self.appModel.showDetailView = true
            }
        }
    }
}
