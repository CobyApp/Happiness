//
//  DetailView.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 10/3/23.
//

import SwiftUI

struct DetailView: View {
    @Binding var event: Event?
    @Binding var showDetailPage: Bool
    
    @State var animateView: Bool = false
    @State var animateContent: Bool = false
    @State var scrollOffset: CGFloat = 0
    
    var body: some View {
        if let event = event {
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    if let uiImage = UIImage(data: event.photo) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                    
                    VStack(spacing: 15){
                        // Dummy Text
                        Text("SFsdf")
                            .multilineTextAlignment(.leading)
                            .lineSpacing(10)
                            .padding(.bottom, 20)
                        
                        Divider()
                        
                        Button {
                            
                        } label: {
                            Label {
                                Text("Share Story")
                            } icon: {
                                Image(systemName: "square.and.arrow.up.fill")
                            }
                            .foregroundColor(.primary)
                            .padding(.vertical,10)
                            .padding(.horizontal,25)
                            .background{
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                    .fill(.ultraThinMaterial)
                            }
                        }
                        
                    }
                    .padding()
                    .offset(y: scrollOffset > 0 ? scrollOffset : 0)
                    .opacity(animateContent ? 1 : 0)
                    .scaleEffect(animateView ? 1 : 0,anchor: .top)
                }
                .offset(y: scrollOffset > 0 ? -scrollOffset : 0)
                .offset(offset: $scrollOffset)
            }
            .coordinateSpace(name: "SCROLL")
            .overlay(alignment: .topTrailing, content: {
                Button {
                    // Closing View
                    withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)){
                        animateView = false
                        animateContent = false
                    }
                    
                    withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7).delay(0.05)){
                        self.event = nil
                        showDetailPage = false
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                }
                .padding()
                .padding(.top, safeArea().top)
                .offset(y: -10)
                .opacity(animateView ? 1 : 0)
            })
            .onAppear {
                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)){
                    animateView = true
                }
                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7).delay(0.1)){
                    animateContent = true
                }
            }
            .transition(.identity)
        }
    }
}
