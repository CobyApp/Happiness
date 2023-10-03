//
//  Home.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 10/3/23.
//

import SwiftUI
import SwiftData

struct Home: View {
    @Environment(\.modelContext) private var context
    
    @Query(sort: \Event.date, order: .reverse)
    private var events: [Event]
    
    @State private var searchText: String = ""
    @State private var isPresented: Bool = false
    
    @State private var activeID: UUID?
    @State private var event: Event?
    @State private var showDetailPage: Bool = false
    
    var body: some View {
        VStack(spacing: 15) {
            HStack(spacing: 12) {
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.gray)
                    
                    TextField("Search", text: $searchText)
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background(.ultraThinMaterial, in: .capsule)
                
                Button(action: {
                    isPresented = true
                }, label: {
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundStyle(.blue)
                })
            }
            .padding(.horizontal, BaseSize.horizantalPadding)
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(events) { event in
                        CardView(event: event)
                            .containerRelativeFrame(.horizontal)
                            .scrollTransition { content, phase in
                                content
                                    .rotation3DEffect(.degrees(phase.value * -30), axis: (x: 0, y: 1, z: 0))
                                    .opacity(phase.isIdentity ? 1.0 : 0.3)
                            }
                            .onTapGesture {
                                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                    self.event = event
                                    showDetailPage = true
                                }
                            }
                    }
                }
                .scrollTargetLayout()
                
                Spacer()
            }
            .contentMargins(.horizontal, BaseSize.horizantalPadding, for: .scrollContent)
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $activeID)
        }
        .sheet(isPresented: $isPresented) {
            EventEdit()
        }
    }
}
