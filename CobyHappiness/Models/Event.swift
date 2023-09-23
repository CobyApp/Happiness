//
//  Event.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 2023/09/21.
//

import SwiftUI
import SwiftData

@Model
class Event: Identifiable {
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
    
    var type: EventType
    var date: Date
    var note: String
    var id: String

    init(id: String = UUID().uuidString, type: EventType = .unspecified, date: Date, note: String) {
        self.type = type
        self.date = date
        self.note = note
        self.id = id
    }
}
