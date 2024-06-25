//
//  LocationModel.swift
//  CobyHappiness
//
//  Created by Coby on 6/9/24.
//

import SwiftUI
import MapKit

struct LocationModel: Codable {
    var lat: Double
    var lon: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: self.lat, longitude: self.lon)
    }
}
