//
//  Detail.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 10/4/23.
//

import SwiftUI
import MapKit

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
                    
                    DetailContent()
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
                withAnimation(.easeInOut(duration: 0.2).delay(0.05)) {
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
    
    @ViewBuilder
    func DetailContent() -> some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading) {
                    HStack(spacing: 10) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(event.title)
                                .font(.title.bold())
                                .foregroundColor(Color.grayscale100)
                            
                            Text(event.date.format("MMM d, yyyy"))
                                .font(.callout.bold())
                                .foregroundColor(Color.grayscale300)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Text(event.note)
                        .font(.callout)
                        .foregroundColor(Color.grayscale200)
                        .multilineTextAlignment(.leading)
                        .padding(.vertical)
                }
                .padding(.horizontal, BaseSize.horizantalPadding)
                
                if let lat = event.lat, let lon = event.lon {
                    MapView(placeName: event.title, location: CLLocationCoordinate2D(latitude: lat, longitude: lon))
                        .frame(width: BaseSize.cardWidth, height: BaseSize.cardWidth * 0.7)
                        .clipShape(.rect(cornerRadius: 15))
                        .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 5)
                }
            }
        }
        .padding(.top, 30)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(.white)
                .ignoresSafeArea()
        }
        .opacity(showDetailContent ? 1 : 0)
        .padding(.top, -100)
    }
}
