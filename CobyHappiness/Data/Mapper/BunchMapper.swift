//
//  BunchMapper.swift
//  CobyHappiness
//
//  Created by Coby Kim on 6/26/24.
//

import UIKit

extension Bunch {
    func toBunchModel() -> BunchModel {
        BunchModel(
            id: self.id,
            startDate: self.startDate,
            endDate: self.endDate,
            title: self.title,
            image: self.image != nil ? UIImage(data: self.image!) : nil,
            imageData: self.image,
            memories: self.memories.map { $0.toMemoryModel() }
        )
    }
}

extension BunchModel {
    func toBunch() -> Bunch {
        Bunch(
            id: self.id,
            startDate: self.startDate,
            endDate: self.endDate,
            title: self.title,
            image: self.imageData
        )
    }
}
