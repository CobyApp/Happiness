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
    
    @State private var isPresented: Bool = false
    
    var event: Event
    var animation: Namespace.ID
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                DetailPhoto()
                    .overlay(alignment: .top, content: DetailHeader)
                
                DetailContent()
            }
        }
        .ignoresSafeArea()
        .background(Color.backgroundPrimary)
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
        .padding(.top, BaseSize.topAreaPadding + 10)
    }
    
    @ViewBuilder
    func DetailPhoto() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(event.photos) { photo in
                    if let uiImage = UIImage(data: photo.image) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: BaseSize.fullWidth, height: BaseSize.fullWidth * 1.2)
                            .clipped()
                            .containerRelativeFrame(.horizontal)
                    }
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .matchedGeometryEffect(id: "image" + event.id.uuidString, in: animation)
    }
    
    @ViewBuilder
    func DetailContent() -> some View {
        VStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.title.bold())
                    .foregroundStyle(Color.grayscale100)
                
                Text(event.date.format("MMM d, yyyy"))
                    .font(.callout.bold())
                    .foregroundStyle(Color.grayscale300)
                
                Text(event.note)
                    .font(.callout)
                    .foregroundColor(Color.grayscale200)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 12)
            }
            .hAlign(.leading)
            .padding(.horizontal, BaseSize.horizantalPadding)
            
            let places = getPlaces()
            if !places.isEmpty {
                MapView(places: places)
                    .frame(width: BaseSize.cardWidth, height: BaseSize.cardWidth * 0.7)
                    .clipShape(.rect(cornerRadius: 15))
            }
        }
        .padding(.vertical, BaseSize.verticalPadding)
        .background(Color.backgroundPrimary)
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
