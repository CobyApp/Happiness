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
    
    @Query(sort: \Memory.date, order: .reverse)
    private var memories: [Memory]
    
    @State private var memory: Memory? = nil
    @State private var isPresented: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            self.HomeTopBarView()
            
            self.MemoryListView()
        }
        .background(Color.backgroundNormalNormal)
        .fullScreenCover(item: self.$memory, onDismiss: { self.memory = nil }) { item in
            DetailView(memory: item)
        }
        .fullScreenCover(isPresented: self.$isPresented) {
            EditMemoryPageView()
        }
    }
    
    @ViewBuilder
    private func HomeTopBarView() -> some View {
        TopBarView(
            leftSide: .none,
            rightSide: .icon,
            rightIcon: Image("plus"),
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
            LazyVStack(spacing: 12) {
                ForEach(self.memories) { memory in
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
            self.memory = memory
        }
    }
}
