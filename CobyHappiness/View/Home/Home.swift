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
    
    var body: some View {
        ScrollView(.vertical) {
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
                
                /// Parallax Carousel
                GeometryReader(content: { geometry in
                    let size = geometry.size
                    
                    ScrollView(.horizontal) {
                        HStack(spacing: 5) {
                            ForEach(events) { event in
                                /// In order to Move the Card in Reverse Direction (Parallax Effect)
                                GeometryReader(content: { proxy in
                                    let cardSize = proxy.size
                                    let minX = min((proxy.frame(in: .scrollView).minX - 30.0) * 1.4, size.width * 1.4)
                                    
                                    Image(systemName: "")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        /// Or You can simply Use scaling
                                        //.scaleEffect(1.25)
                                        .offset(x: -minX)
                                        /// Disable this for Type one Effect
                                        .frame(width: proxy.size.width * 2.5)
                                        .frame(width: cardSize.width, height: cardSize.height)
                                        .overlay {
                                            OverlayView(event)
                                        }
                                        .clipShape(.rect(cornerRadius: 15))
                                        .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y: 10)
                                })
                                .frame(width: size.width - 60, height: size.height - 50)
                                /// Scroll Animation
                                .scrollTransition(.interactive, axis: .horizontal) { view, phase in
                                    view
                                        .scaleEffect(phase.isIdentity ? 1 : 0.95)
                                }
                            }
                        }
                        .padding(.horizontal, 30)
                        .scrollTargetLayout()
                        .frame(height: size.height, alignment: .top)
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .scrollIndicators(.hidden)
                })
                .frame(height: BaseSize.fullHeight)
                .padding(.horizontal, -15)
                .padding(.top, 10)
            }
            .padding(15)
        }
        .scrollIndicators(.hidden)
        .sheet(isPresented: $isPresented) {
            EventEdit()
        }
    }
    
    /// Overlay View
    @ViewBuilder
    func OverlayView(_ event: Event) -> some View {
        ZStack(alignment: .bottomLeading, content: {
            LinearGradient(colors: [
                .clear,
                .clear,
                .clear,
                .clear,
                .clear,
                .black.opacity(0.1),
                .black.opacity(0.5),
                .black
            ], startPoint: .top, endPoint: .bottom)
            
            VStack(alignment: .leading, spacing: 4, content: {
                Text(event.title)
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundStyle(.white)
                
                Text(event.date.format("yyyy-mm-dd"))
                    .font(.callout)
                    .foregroundStyle(.white.opacity(0.8))
            })
            .padding(20)
        })
    }
}
