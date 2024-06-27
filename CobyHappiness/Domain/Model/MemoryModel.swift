//
//  MemoryModel.swift
//  CobyHappiness
//
//  Created by Coby Kim on 6/26/24.
//

import Foundation

struct MemoryModel: Codable, Identifiable, Hashable, Equatable {
    var id: UUID
    var date: Date
    var type: MemoryType
    var title: String
    var note: String
    var location: LocationModel?
    var photos: [Data]
    var bunches: [BunchModel]
    
    init(
        id: UUID = UUID(),
        date: Date = .now,
        type: MemoryType = .moment,
        title: String = "",
        note: String = "",
        location: LocationModel? = nil,
        photos: [Data] = [],
        bunches: [BunchModel] = []
    ) {
        self.id = id
        self.date = date
        self.type = type
        self.title = title
        self.note = note
        self.location = location
        self.photos = photos
        self.bunches = bunches
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
