//
//  Paper.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 2023/09/21.
//

import SwiftUI
import SwiftData

@Model
final class Paper {
    @Attribute(.unique) var id: UUID
    @Relationship(deleteRule: .cascade) var events: [Event]
    var date: Date
    var happyPoint: Int // 0: 평범, 1: 행복, 2: 무지 행복
    var weather: Int // 0: 흐림, 1: 비, 2: 맑음

    init() {
        self.id = UUID()
        self.date = Date()
        self.events = EventType.allCases.map { Event(type: $0) }
        self.happyPoint = 1
        self.weather = 2
    }
}
