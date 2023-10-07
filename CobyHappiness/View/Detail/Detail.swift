//
//  Detail.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 10/4/23.
//

import SwiftUI

struct Detail: View {
    @EnvironmentObject private var appModel: AppViewModel
    
    @State private var showDetailContent: Bool = false
    @State private var isPresented: Bool = false
    
    var event: Event
    var animation: Namespace.ID
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    if let uiImage = UIImage(data: event.photo) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .matchedGeometryEffect(id: event.id.uuidString, in: animation)
                            .frame(width: size.width, height: size.height * (2/3))
                            .clipped()
                    }
                    
                    VStack(alignment: .leading) {
                        HStack(spacing: 10) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(event.title)
                                    .font(.title.bold())
                                    .foregroundColor(Color.grayscale100)
                                
                                Text(event.date.format("MMM d, yyyy"))
                                    .font(.caption2)
                                    .bold()
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        Text(event.note)
                            .font(.callout)
                            .foregroundColor(Color.grayscale200)
                            .multilineTextAlignment(.leading)
                            .padding(.vertical)
                    }
                    .padding(.top, 30)
                    .padding(.horizontal, BaseSize.horizantalPadding)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .background {
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(.white)
                            .ignoresSafeArea()
                    }
                    .opacity(showDetailContent ? 1 : 0)
                    .padding(.top, -80)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .ignoresSafeArea()
                
                DetailHeader()
            }
        }
        .onAppear {
            withAnimation(.easeInOut) {
                showDetailContent = true
            }
        }
        .sheet(isPresented: $isPresented) {
            EventEdit(event: event)
        }
    }
        
    
    @ViewBuilder
    func DetailHeader() -> some View {
        HStack {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    showDetailContent = false
                }
                withAnimation(.easeInOut(duration: 0.2).delay(0.01)) {
                    appModel.showDetailView = false
                }
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(Color.black)
                    .padding(12)
                    .background {
                        Circle()
                            .fill(.white)
                    }
            }
            
            Spacer()
            
            Button {
                isPresented = true
            } label: {
                Image(systemName: "suit.heart.fill")
                    .foregroundColor(Color.red)
                    .padding(12)
                    .background {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.white)
                    }
            }
        }
        .padding()
        .opacity(showDetailContent ? 1 : 0)
    }
}
