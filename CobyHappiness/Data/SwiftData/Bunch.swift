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
    
    var id: UUID
    var startDate: Date
    var endDate: Date
    var title: String
    var image: Data?
    @Relationship(deleteRule: .nullify, inverse: \Memory.bunches)
    var memories: [Memory]
    
    init(
        id: UUID = UUID(),
        startDate: Date,
        endDate: Date,
        title: String,
        image: Data? = nil,
        memories: [Memory] = []
    ) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.title = title
        self.image = image
        self.memories = memories
    }
}
