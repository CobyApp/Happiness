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
            image: self.image.flatMap { UIImage(data: $0) },
            imageData: self.image,
            memories: self.memories?.map { $0.toMemoryModel() }.sorted { $0.date < $1.date } ?? [],
            isFirst: false
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
