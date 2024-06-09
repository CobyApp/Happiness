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
    @State private var isDetailPresented: Bool = false
    @State private var isEditPresented: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            self.HomeTopBarView()
            
            self.EventListView()
        }
        .background(Color.backgroundNormalNormal)
        .fullScreenCover(isPresented: self.$isDetailPresented) {
            if let event = self.event {
                DetailView(
                    isPresented: self.$isDetailPresented,
                    event: event
                )
            }
        }
        .fullScreenCover(isPresented: self.$isEditPresented) {
            EditView(
                isPresented: self.$isEditPresented
            )
        }
    }
    
    @ViewBuilder
    private func HomeTopBarView() -> some View {
        TopBarView(
            leftSide: .none,
            rightSide: .icon,
            rightIcon: Image("plus"),
            rightAction: {
                self.isEditPresented = true
            }
        )
        .overlay(alignment: .leading) {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(height: 50)
                .foregroundColor(Color.labelNormal)
                .padding(.top, 10)
                .padding(.leading, 20)
        }
        .padding(.bottom, 12)
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
            image: event.photos.first?.image.image,
            title: event.title,
            discription: event.date.format("MMM d, yyyy")
        )
        .frame(width: BaseSize.fullWidth, height: BaseSize.fullWidth * 0.8)
        .onTapGesture {
            print(event)
            self.event = event
            self.isDetailPresented = true
        }
    }
}
