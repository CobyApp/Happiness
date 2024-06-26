//
//  BunchModel.swift
//  CobyHappiness
//
//  Created by Coby Kim on 6/26/24.
//

import UIKit

struct BunchModel: Codable, Identifiable, Hashable, Equatable {
    var id: UUID
    var startDate: Date
    var endDate: Date
    var title: String
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
