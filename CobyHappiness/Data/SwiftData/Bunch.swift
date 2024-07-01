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
    var startDate: Date
    var endDate: Date
    var title: String
    @Relationship(deleteRule: .nullify, inverse: \Memory.bunches)
    var memories: [Memory]
    
    init(
        id: UUID = UUID(),
        startDate: Date,
        endDate: Date,
        title: String,
        memories: [Memory] = []
    ) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.title = title
        self.memories = memories
    }
}
