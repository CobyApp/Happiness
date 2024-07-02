//
//  SaveBunchRequest.swift
//  CobyHappiness
//
//  Created by Coby on 7/2/24.
//

import Foundation

struct SaveBunchRequest: Codable {
    let id: UUID
    let startDate: Date
    let endDate: Date
    let title: String
    let memoryIds: [UUID]
}
