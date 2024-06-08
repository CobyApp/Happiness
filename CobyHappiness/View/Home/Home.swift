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
    @State private var activeID: UUID?
    
    var animation: Namespace.ID
    
    var body: some View {
        VStack(spacing: 0) {
            CustomHeader(isPresented: $isPresented, searchText: $searchText)
                .padding(.top, 10)
            
            CustomMenu(currentMenu: $currentMenu, animation: animation)
                .padding(.top, 20)
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(events) { event in
                        Group {
                            if appModel.showDetailView {
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(width: BaseSize.cardWidth, height: BaseSize.cardWidth * 1.2)
                            } else {
                                CardView(event: event, animation: animation)
                                    .onTapGesture {
                                        withAnimation(.spring()) {
                                            appModel.currentActiveItem = event
                                            appModel.showDetailView = true
                                        }
                                    }
                            }
                        }
                        .padding(.vertical, 20)
                        .containerRelativeFrame(.horizontal)
                        .scrollTransition { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1.0 : 0.5)
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .contentMargins(.horizontal, BaseSize.horizantalPadding, for: .scrollContent)
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $activeID)
            
            Spacer()
        }
        .onChange(of: events.count) {
            withAnimation {
                if !events.isEmpty {
                    activeID = events[0].id
                }
            }
        }
        .sheet(isPresented: $isPresented) {
            EventEdit()
        }
    }
}
