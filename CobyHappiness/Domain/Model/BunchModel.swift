//
//  BunchModel.swift
//  CobyHappiness
//
//  Created by Coby Kim on 6/26/24.
//

import UIKit

struct BunchModel: Identifiable, Hashable, Equatable {
    var id: UUID
    var startDate: Date
    var endDate: Date
    var title: String
    var image: UIImage?
    var imageData: Data?
    var memories: [MemoryModel]
    var isFirst: Bool = true
    
    init(
        id: UUID = UUID(),
        startDate: Date = .now,
        endDate: Date = .now,
        title: String = "",
        image: UIImage? = nil,
        imageData: Data? = nil,
        memories: [MemoryModel] = [],
        isFirst: Bool = true
    ) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.title = title
        self.image = image
        self.imageData = imageData
        self.memories = memories
        self.isFirst = isFirst
    }
    
    var term: String {
        let startDate = self.startDate.format("yy년 MM월 dd일")
        let endDate = self.endDate.format("yy년 MM월 dd일")
        
        if startDate == endDate {
            return startDate
        } else {
            return "\(startDate) ~ \(endDate)"
        }
    }
    
    var termShort: String {
        let startDate = self.startDate.format("yy.MM.dd")
        let endDate = self.endDate.format("yy.MM.dd")
        
        if startDate == endDate {
            return startDate
        } else {
            return "\(startDate) ~ \(endDate)"
        }
    }
    
    var photos: [UIImage] {
        self.memories.flatMap { $0.photos }
    }
}
