//
//  Date+Extensions.swift
//  CobyHappiness
//
//  Created by Coby on 7/6/24.
//

import Foundation

extension Date {
    var formatMid: String {
        self.format("yy년 MM월 dd일")
    }
    
    var formatLong: String {
        self.format("yyyy년 MM월 dd일")
    }
    
    var formatShort: String {
        self.format("yy.MM.dd")
    }
}
