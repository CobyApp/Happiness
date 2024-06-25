//
//  Memory.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 2023/09/24.
//

import SwiftUI
import SwiftData

@Model
final class Memory {
    
    @Attribute(.unique)
    var id: UUID
    var date: Date
    var type: MemoryType
    var title: String
    var note: String
    var location: Location?
    var photos: [Data]
    var bunches: [Bunch]

    init(
        id: UUID = UUID(),
        date: Date = .now,
        type: MemoryType = .moment,
        title: String = "",
        note: String = "",
        location: Location? = nil,
        photos: [Data] = [],
        bunches: [Bunch] = []
    ) {
        self.id = id
        self.date = date
        self.type = type
        self.title = title
        self.note = note
        self.location = location
        self.photos = photos
        self.bunches = bunches
    }
}
