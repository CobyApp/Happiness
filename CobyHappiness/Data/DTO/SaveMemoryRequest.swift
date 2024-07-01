//
//  SaveMemoryRequest.swift
//  CobyHappiness
//
//  Created by Coby on 7/2/24.
//

import Foundation

struct SaveMemoryRequest: Codable {
    let id: UUID
    let date: Date
    let type: MemoryType
    let title: String
    let note: String
    let location: LocationModel?
    let photos: [Data]
}
