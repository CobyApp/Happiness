//
//  PlaceModel.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 10/14/23.
//

import SwiftUI
import MapKit

struct PlaceModel: Identifiable {
    var id = UUID()
    var name: String
    var location: CLLocationCoordinate2D
}
