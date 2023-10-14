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
    
    @State private var scale: CGFloat = 1
    @State private var isPresented: Bool = false
    
    var event: Event
    var animation: Namespace.ID
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                DetailPhoto()
                
                DetailContent()
            }
        }
        .background(Color.backgroundPrimary)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .scaleEffect(scale)
        .ignoresSafeArea()
        .overlay(alignment: .top, content: DetailHeader)
        .sheet(isPresented: $isPresented) {
            EventEdit(event: event)
        }
    }
    
    @ViewBuilder
    func DetailHeader() -> some View {
        HStack {
            Button {
                withAnimation(.spring()) {
                    appModel.showDetailView = false
                }
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(Color.black.opacity(0.7))
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .clipShape(Circle())
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
        .padding(.horizontal, BaseSize.horizantalPadding)
        .padding(.top, 10)
        .opacity(scale == 1 ? 1 : 0)
    }
    
    @ViewBuilder
    func DetailPhoto() -> some View {
        GeometryReader { reader in
            ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                if let uiImage = UIImage(data: event.photos[0].image) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .matchedGeometryEffect(id: "image" + event.id.uuidString, in: animation)
                        .frame(width: BaseSize.fullWidth, height: BaseSize.fullWidth * 1.2)
                        .clipped()
                }
            }
            .offset(y: (reader.frame(in: .global).minY > 0 && scale == 1) ? -reader.frame(in: .global).minY : 0)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let scale = value.translation.height / UIScreen.main.bounds.height
                        
                        if 1 - scale > 0.8 && 1 - scale <= 1  {
                            self.scale = 1 - scale
                        }
                    }
                    .onEnded { value in
                        if scale < 0.9 {
                            appModel.showDetailView = false
                        }
                        scale = 1
                    }
            )
        }
        .frame(width: BaseSize.fullWidth, height: BaseSize.fullWidth * 1.2)
    }
    
    @ViewBuilder
    func DetailContent() -> some View {
        VStack {
            VStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.title)
                        .font(.title.bold())
                        .foregroundStyle(Color.grayscale100)
                    
                    Text(event.date.format("MMM d, yyyy"))
                        .font(.callout.bold())
                        .foregroundStyle(Color.grayscale300)
                }
                
                Text(event.note)
                    .font(.callout)
                    .foregroundColor(Color.grayscale200)
                    .multilineTextAlignment(.leading)
            }
            .hAlign(.leading)
            .padding(BaseSize.horizantalPadding)
            
//            if let lat = event.lat, let lon = event.lon {
//                MapView(placeName: event.title, location: CLLocationCoordinate2D(latitude: lat, longitude: lon))
//                    .frame(width: BaseSize.cardWidth, height: BaseSize.cardWidth * 0.7)
//                    .clipShape(.rect(cornerRadius: 15))
//            }
        }
        .background(Color.backgroundPrimary)
    }
}
