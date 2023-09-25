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
    case music, video, food, flex, moment
    
    var id: String {
        self.rawValue
    }
    
    var description: String {
        switch self {
        case .music:
            return "기분이 좋아지는 음악"
        case .video:
            return "보기만 해도 힐링되는 영상"
        case .food:
            return "나를 행복하게 하는 음식"
        case .flex:
            return "스트레스가 풀리는 플렉스"
        case .moment:
            return "오늘 가장 행복했던 순간"
        }
    }

    var icon: String {
        switch self {
        case .music:
            return "🏦"
        case .video:
            return "🏡"
        case .food:
            return "🎉"
        case .flex:
            return "🏟"
        case .moment:
            return "📌"
        }
    }
}
