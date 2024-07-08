//
//  MemoryModel.swift
//  CobyHappiness
//
//  Created by Coby Kim on 6/26/24.
//

import UIKit

struct MemoryModel: Identifiable, Hashable, Equatable {
    var id: UUID
    var date: Date
    var type: MemoryType
    var title: String
    var note: String
    var location: LocationModel?
    var photos: [UIImage]
    var photosData: [Data]
    var bunches: [BunchModel]
    var isFirst: Bool = true
    
    init(
        id: UUID = UUID(),
        date: Date = .now,
        type: MemoryType = .trip,
        title: String = "",
        note: String = "",
        location: LocationModel? = nil,
        photos: [UIImage] = [],
        photosData: [Data] = [],
        bunches: [BunchModel] = [],
        isFirst: Bool = true
    ) {
        self.id = id
        self.date = date
        self.type = type
        self.title = title
        self.note = note
        self.location = location
        self.photos = photos
        self.photosData = photosData
        self.bunches = bunches
        self.isFirst = isFirst
    }
    
    var isFirstPageDisabled: Bool {
        self.photosData.isEmpty
    }
    
    var isSecondPageDisabled: Bool {
        self.title == "" || self.note == ""
    }
    
    var isDisabled: Bool {
        self.isFirstPageDisabled || self.isSecondPageDisabled
    }
}

extension [MemoryModel] {
    func getFilteredMemories(_ type: MemoryType?) -> [MemoryModel] {
        if let type = type {
            self.filter { $0.type == type }
        } else {
            self
        }
    }
}
