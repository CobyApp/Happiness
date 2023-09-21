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
    var id: String
    var date: Date
    var note: String

    init(id: String = UUID().uuidString, date: Date, note: String) {
        self.date = date
        self.note = note
        self.id = id
    }
}
