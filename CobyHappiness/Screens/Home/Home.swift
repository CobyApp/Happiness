//
//  Home.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 10/3/23.
//

import SwiftUI
import SwiftData

import CobyDS

struct Home: View {
    
    @Environment(\.namespace) private var animation
    @Environment(\.modelContext) private var context
    
    @EnvironmentObject private var appModel: AppViewModel
    
    @Query(sort: \Event.date, order: .reverse)
    private var events: [Event]
    
    @State private var isPresented: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(
                leftSide: .text,
                leftTitle: "",
                rightSide: .icon,
                rightIcon: Image("add"),
                rightAction: {
                    self.isPresented = true
                }
            )
            .overlay(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                    .padding(.top, 10)
                    .padding(.leading, 20)
            }
            .padding(.bottom, 12)
        
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(self.events) { event in
                        var image: Image? {
                            if let data = event.photos.first?.image, let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                            } else {
                                nil
                            }
                        }
                        
                        ThumbnailCardView(
                            image: image,
                            title: event.title,
                            discription: event.note
                        )
                        .frame(width: BaseSize.fullWidth, height: BaseSize.fullWidth * 0.8)
                        .matchedGeometryEffect(id: "image" + event.id.uuidString, in: self.animation)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                self.appModel.currentActiveItem = event
                                self.appModel.showDetailView = true
                            }
                        }
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .background(Color.backgroundNormalNormal)
        .sheet(isPresented: self.$isPresented) {
            EventEdit()
        }
    }
}
