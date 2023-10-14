//
//  Photo.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 10/14/23.
//

import SwiftUI
import SwiftData

@Model
final class Photo {
    @Attribute(.unique) var id: UUID
    var date: Date
    var image: Data
    var lat: Double?
    var lon: Double?

    init(
        date: Date,
        image: Data,
        lat: Double? = nil,
        lon: Double? = nil
    ) {
        self.id = UUID()
        self.date = date
        self.image = image
        self.lat = lat
        self.lon = lon
    }
}
