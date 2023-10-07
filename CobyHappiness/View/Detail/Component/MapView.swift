//
//  MapView.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 10/7/23.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var cameraPosition: MapCameraPosition
    
    private var placeName: String
    private var location: CLLocationCoordinate2D
    private var myRegion: MKCoordinateRegion
    
    init(placeName: String, location: CLLocationCoordinate2D) {
        self.placeName = placeName
        self.location = location
        self.myRegion = .init(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
        self._cameraPosition = State(wrappedValue: .region(myRegion))
    }
    
    var body: some View {
        Map(position: $cameraPosition) {
            Marker(placeName, coordinate: location)
                .tint(.blue)
        }
    }
}
