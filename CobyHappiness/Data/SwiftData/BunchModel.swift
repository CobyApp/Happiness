//
//  BunchModel.swift
//  CobyHappiness
//
//  Created by Coby on 6/11/24.
//

import SwiftUI
import SwiftData

@Model
final class BunchModel {
    
    @Attribute(.unique)
    var id: UUID
    var startDate: Date
    var endDate: Date
    var title: String
    @Relationship(deleteRule: .nullify, inverse: \MemoryModel.bunches)
    var memories: [MemoryModel]
    
    init(
        id: UUID = UUID(),
        startDate: Date = .now,
        endDate: Date = .now,
        title: String = "",
        memories: [MemoryModel] = []
    ) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.title = title
        self.memories = memories
    }
    
    var image: UIImage? {
        self.memories.first?.photos.first?.image
    }
    
    var term: String {
        let startDate = self.startDate.format("MMM d, yyyy")
        let endDate = self.endDate.format("MMM d, yyyy")
        
        if startDate == endDate {
            return startDate
        } else {
            return "\(startDate) ~ \(endDate)"
        }
    }
}
