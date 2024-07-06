//
//  MemoryType.swift
//  CobyHappiness
//
//  Created by Coby on 6/25/24.
//

import Foundation

enum MemoryType: String, Identifiable, CaseIterable, Codable {
    case trip, food, hobby, moment
    
    var id: String {
        self.rawValue
    }
    
    var title: String {
        switch self {
        case .trip:
            return "여행"
        case .food:
            return "음식"
        case .hobby:
            return "취미"
        case .moment:
            return "순간"
        }
    }
    
    var description: String {
        switch self {
        case .trip:
            return "여행의 즐거움을 담은 사진을 골라주세요."
        case .food:
            return "맛있는 음식을 즐겼던 사진을 골라주세요."
        case .hobby:
            return "내가 좋아하는 것들의 사진을 골라주세요."
        case .moment:
            return "기억에 남는 특별한 순간의 사진을 골라주세요."
        }
    }
}
