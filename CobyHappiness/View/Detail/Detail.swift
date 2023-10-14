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
    
    @State private var offset: CGFloat = 0.0
    @State private var dragOffset: CGFloat = 0.0
    
    @State private var scale: CGFloat = 1
    @State private var isPresented: Bool = false
    
    @State private var image: UIImage?
    
    var event: Event
    var animation: Namespace.ID
    
    var body: some View {
        GeometryReader { reader in
            VStack {
                if let uiImage = UIImage(data: event.photos[0].image) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .matchedGeometryEffect(id: "image" + event.id.uuidString, in: animation)
                        .frame(width: BaseSize.fullWidth, height: BaseSize.fullWidth * 1.2)
                        .clipped()
                }
                
                DetailContent()
            }
            .frame(width: reader.size.width)
            .offset(y: offset + dragOffset)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let dragOffset = value.translation.height
                        if self.offset + dragOffset > 0 {
                            let scale = value.translation.height / UIScreen.main.bounds.height
                            
                            if 1 - scale > 0.8 && 1 - scale <= 1  {
                                self.scale = 1 - scale
                            }
                        } else {
                            if self.scale == 1 {
                                self.dragOffset = dragOffset
                            }
                        }
                    }
                    .onEnded { value in
                        offset += value.translation.height
                        dragOffset = 0
                        
                        if scale < 0.9 {
                            appModel.showDetailView = false
                        }
                        scale = 1
                    }
            )
        }
        .background(Color.backgroundPrimary)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .scaleEffect(scale)
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
            
            let places = getPlaces()
            if !places.isEmpty {
                MapView(places: places)
                    .frame(width: BaseSize.cardWidth, height: BaseSize.cardWidth * 0.7)
                    .clipShape(.rect(cornerRadius: 15))
            }
        }
        .background(Color.backgroundPrimary)
        .clipShape(RoundedRectangle(cornerRadius: 30))
    }
    
    private func getPlaces() -> [Place] {
        var places = [Place]()
        for photo in event.photos {
            if let lat = event.photos.first?.lat, let lon = event.photos.first?.lon {
                places.append(
                    Place(
                        name: photo.date.format("MMM d, yyyy"),
                        location: CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    )
                )
            }
        }
        return places
    }
}
