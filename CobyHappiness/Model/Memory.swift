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

enum MemoryType: String, Identifiable, CaseIterable, Codable {
    case trip, food, hobby, concert, flex, moment
    
    var id: String {
        self.rawValue
    }
    
    var title: String {
        switch self {
        case .trip:
            return "여행"
        case .food:
            return "음식"
        case .hobby:
            return "취미"
        case .concert:
            return "공연"
        case .flex:
            return "소비"
        case .moment:
            return "순간"
        }
    }
}
