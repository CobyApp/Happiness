//
//  Event.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 2023/09/24.
//

import SwiftUI
import SwiftData

@Model
final class Event {
    @Attribute(.unique) var id: UUID
    var date: Date
    var type: EventType
    var note: String
    
    init(type: EventType) {
        self.id = UUID()
        self.date = Date()
        self.type = type
        self.note = ""
    }
}

enum EventType: String, Identifiable, CaseIterable, Codable {
    case work, home, social, sport, unspecified
    
    var id: String {
        self.rawValue
    }

    var icon: String {
        switch self {
        case .work:
            return "🏦"
        case .home:
            return "🏡"
        case .social:
            return "🎉"
        case .sport:
            return "🏟"
        case .unspecified:
            return "📌"
        }
    }
}
