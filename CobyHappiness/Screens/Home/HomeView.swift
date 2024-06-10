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
    
    @Environment(\.modelContext) private var context
    
    @Query(sort: \Event.date, order: .reverse)
    private var events: [Event]
    
    @State private var event: Event? = nil
    @State private var isPresented: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            self.HomeTopBarView()
            
            self.EventListView()
        }
        .background(Color.backgroundNormalNormal)
        .fullScreenCover(item: self.$event, onDismiss: { self.event = nil }) { item in
            DetailView(event: item)
        }
        .fullScreenCover(isPresented: self.$isPresented) {
            EditView()
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
    private func EventListView() -> some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(self.events) { event in
                    self.EventThumbnailView(for: event)
                }
            }
            .padding(.bottom, 20)
        }
    }
    
    @ViewBuilder
    private func EventThumbnailView(for event: Event) -> some View {
        ThumbnailCardView(
            image: event.photos.first?.image,
            title: event.title,
            description: event.date.format("MMM d, yyyy"),
            isShadowing: true
        )
        .frame(width: BaseSize.fullWidth, height: BaseSize.fullWidth * 0.8)
        .onTapGesture {
            self.event = event
        }
    }
}
