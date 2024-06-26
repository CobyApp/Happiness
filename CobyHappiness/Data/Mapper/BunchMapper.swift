//
//  BunchMapper.swift
//  CobyHappiness
//
//  Created by Coby Kim on 6/26/24.
//

import Foundation

extension Bunch {
    func toBunchModel() -> BunchModel {
        BunchModel(
            id: self.id,
            startDate: self.startDate,
            endDate: self.endDate,
            title: self.title,
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
            memories: self.memories.map { $0.toMemory() }
        )
    }
}
