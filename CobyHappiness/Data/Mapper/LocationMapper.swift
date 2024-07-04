//
//  LocationMapper.swift
//  CobyHappiness
//
//  Created by Coby on 7/4/24.
//

import Foundation
import MapKit

extension CLLocationCoordinate2D {
    func toLocationModel() -> LocationModel {
        LocationModel(
            lat: self.latitude,
            lon: self.longitude
        )
    }
}

extension LocationModel {
    func toCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: self.lat,
            longitude: self.lon
        )
    }
}
