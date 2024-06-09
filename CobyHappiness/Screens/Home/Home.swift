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
    
    @EnvironmentObject private var appModel: AppViewModel
    @Environment(\.modelContext) private var context
    @Environment(\.namespace) var animation
    
    @Query(sort: \Event.date, order: .reverse)
    private var events: [Event]
    
    @State private var isPresented: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(
                leftSide: .text,
                leftTitle: "happy",
                rightSide: .icon,
                rightIcon: Image("add"),
                rightAction: {
                    self.isPresented = true
                }
            )
        
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
                .padding(.vertical, 12)
            }
        }
        .background(Color.backgroundNormalNormal)
        .sheet(isPresented: self.$isPresented) {
            EventEdit()
        }
    }
}
