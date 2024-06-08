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
    
    @Query(sort: \Event.date, order: .reverse)
    private var events: [Event]
    
    @State private var isPresented: Bool = false
    @State private var searchText: String = ""
    @State private var currentMenu: EventType = .music
    
    var animation: Namespace.ID
    
    var body: some View {
        VStack(spacing: 0) {
            CustomHeader(isPresented: $isPresented, searchText: $searchText)
                .padding(.top, 10)
            
            CustomMenu(currentMenu: $currentMenu, animation: animation)
                .padding(.top, 20)
            
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
                        .matchedGeometryEffect(id: "image" + event.id.uuidString, in: animation)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                appModel.currentActiveItem = event
                                appModel.showDetailView = true
                            }
                        }
                    }
                }
                .padding(.vertical, 12)
            }
        }
        .loadCustomFonts()
        .sheet(isPresented: $isPresented) {
            EventEdit()
        }
    }
}
