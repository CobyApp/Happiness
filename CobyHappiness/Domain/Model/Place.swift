//
//  Place.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 10/14/23.
//

import SwiftUI
import MapKit

struct Place: Identifiable {
    var id = UUID()
    var name: String
    var location: CLLocationCoordinate2D
}
