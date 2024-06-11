//
//  Bunch.swift
//  CobyHappiness
//
//  Created by Coby on 6/11/24.
//

import SwiftUI
import SwiftData

@Model
final class Bunch {
    
    @Attribute(.unique)
    var id: UUID
    var date: Date
    var title: String
    var note: String
    @Relationship(deleteRule: .cascade)
    var events: [Event]
    
    init(
        id: UUID = UUID(),
        date: Date,
        title: String,
        note: String, 
        events: [Event]
    ) {
        self.id = id
        self.date = date
        self.title = title
        self.note = note
        self.events = events
    }
    
    var image: Image? {
        self.events.first?.photos.first?.image
    }
}
