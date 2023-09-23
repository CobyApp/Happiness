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

    init() {
        self.id = UUID()
        self.date = Date()
        self.events = EventType.allCases.map { Event(type: $0) }
    }
}
