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
    @State private var scale: CGFloat = 1
    @State private var isDown: Bool = false
    @State private var photos = [UIImage]()
    
    var event: Event
    var animation: Namespace.ID
    
    init(event: Event, animation: Namespace.ID) {
        self.event = event
        self.animation = animation
        self._photos = State(wrappedValue: event.photos.map { UIImage(data: $0.image)! })
    }
    
    var body: some View {
        CustomScrollView(showDetailView: $appModel.showDetailView, scale: $scale, isDown: $isDown) {
            VStack(spacing: 0) {
                DetailPhoto()
                
                DetailContent()
            }
        }
        .overlay(alignment: .top, content: DetailHeader)
        .background(Color.backgroundPrimary)
        .clipShape(RoundedRectangle(cornerRadius: scale == 1 ? 0 : 30))
        .scaleEffect(scale)
        .ignoresSafeArea()
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
                    .foregroundColor(isDown ? Color.white.opacity(0.8) : Color.black.opacity(0.7))
                    .padding()
                    .background(isDown ? Color.black.opacity(0.7) : Color.white.opacity(0.8))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            Button {
                isPresented = true
            } label: {
                Image(systemName: "suit.heart.fill")
                    .foregroundColor(isDown ? Color.white.opacity(0.8) : Color.black.opacity(0.7))
                    .padding()
                    .background(isDown ? Color.black.opacity(0.7) : Color.white.opacity(0.8))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, BaseSize.horizantalPadding)
        .padding(.top, BaseSize.topAreaPadding + 10)
    }
    
    @ViewBuilder
    func DetailPhoto() -> some View {
        TabView() {
            ForEach(photos, id: \.self) { photo in
                Image(uiImage: photo)
                    .resizable()
                    .scaledToFill()
                    .frame(width: BaseSize.fullWidth, height: BaseSize.fullWidth * 1.2)
                    .clipped()
                    .ignoresSafeArea()
            }
        }
        .frame(width: BaseSize.fullWidth, height: BaseSize.fullWidth * 1.2)
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .matchedGeometryEffect(id: "image" + event.id.uuidString, in: animation)
        .onAppear {
            UIScrollView.appearance().bounces = false
        }
    }
    
    @ViewBuilder
    func DetailContent() -> some View {
        VStack(alignment: .leading, spacing: BaseSize.verticalPadding) {
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.title.bold())
                    .foregroundStyle(Color.grayscale100)
                
                Text(event.date.format("MMM d, yyyy"))
                    .font(.callout.bold())
                    .foregroundStyle(Color.grayscale300)
            }
            
            Divider()
                .frame(height: 1)
                .foregroundColor(Color.borderDefault)
            
            Text(event.note)
                .font(.callout)
                .foregroundColor(Color.grayscale200)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            
            let places = getPlaces()
            if !places.isEmpty {
                Divider()
                    .frame(height: 1)
                    .foregroundColor(Color.borderDefault)
                
                MapView(places: places)
                    .frame(maxWidth: .infinity)
                    .frame(height: BaseSize.cardWidth * 0.7)
                    .clipShape(.rect(cornerRadius: 15))
            }
        }
        .padding(.horizontal, BaseSize.horizantalPadding)
        .padding(.top, BaseSize.verticalPadding)
        .padding(.bottom, BaseSize.bottomAreaPadding + BaseSize.verticalPadding)
        .background(Color.backgroundPrimary)
        .animation(nil, value: UUID())
    }
    
    private func getPlaces() -> [Place] {
        var places = [Place]()
        for photo in event.photos {
            if let lat = photo.lat, let lon = photo.lon {
                places.append(
                    Place(
                        name: event.title,
                        location: CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    )
                )
            }
        }
        return places
    }
}
