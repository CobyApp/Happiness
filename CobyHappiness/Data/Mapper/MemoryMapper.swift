//
//  MemoryMapper.swift
//  CobyHappiness
//
//  Created by Coby Kim on 6/26/24.
//

import UIKit

extension Memory {
    func toMemoryModel() -> MemoryModel {
        MemoryModel(
            id: self.id,
            date: self.date,
            type: self.type,
            title: self.title,
            note: self.note,
            location: self.location,
            photos: self.photos.compactMap { $0.image },
            bunches: self.bunches.map { $0.toBunchModel() }
        )
    }
}
