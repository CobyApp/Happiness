//
//  MapItemView.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 10/7/23.
//

import SwiftUI
import MapKit

struct MapItemView: View {
    @State private var cameraPosition: MapCameraPosition
    
    private var places: [Place]
    
    init(places: [Place]) {
        self.places = places
        self._cameraPosition = State(
            wrappedValue: .region(
                MKCoordinateRegion(
                    center: places[0].location,
                    latitudinalMeters: 1000,
                    longitudinalMeters: 1000
                )
            )
        )
    }
    
    var body: some View {
        Map(position: $cameraPosition) {
            ForEach(places) { place in
                Marker(place.name, coordinate: place.location)
                    .tint(.blue)
            }
        }
    }
}
