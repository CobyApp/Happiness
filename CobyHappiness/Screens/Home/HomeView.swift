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
    
    @Environment(\.namespace) private var animation
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var appModel: AppViewModel
    
    @Query(sort: \Event.date, order: .reverse)
    private var events: [Event]
    
    @State private var isPresented: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            self.HomeTopBarView()
            
            self.EventsListView()
        }
        .background(Color.backgroundNormalNormal)
        .sheet(isPresented: self.$isPresented) {
            EventEditView()
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
                .frame(height: 50)
                .foregroundColor(Color.labelNormal)
                .padding(.top, 10)
                .padding(.leading, 20)
        }
        .padding(.bottom, 12)
    }
    
    @ViewBuilder
    private func EventsListView() -> some View {
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
        var image: Image? {
            if let data = event.photos.first?.image, let uiImage = UIImage(data: data) {
                return Image(uiImage: uiImage)
            } else {
                return nil
            }
        }
        
        ThumbnailCardView(
            image: image,
            title: event.title,
            discription: event.note
        )
        .frame(width: BaseSize.fullWidth, height: BaseSize.fullWidth * 0.8)
        .matchedGeometryEffect(id: event.id, in: self.animation)
        .onTapGesture {
            withAnimation(.spring()) {
                self.appModel.currentActiveItem = event
                self.appModel.showDetailView = true
            }
        }
    }
}
