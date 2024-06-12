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
    var date: Date
    var title: String
    var note: String
    @Relationship(deleteRule: .nullify)
    var memories: [Memory]
    
    init(
        id: UUID = UUID(),
        date: Date,
        title: String,
        note: String,
        memories: [Memory]
    ) {
        self.id = id
        self.date = date
        self.title = title
        self.note = note
        self.memories = memories
    }
    
    var image: UIImage? {
        self.memories.first?.photos.first?.image
    }
}
