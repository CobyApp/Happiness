//
//  Date+Extensions.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 2023/09/21.
//

import Foundation

extension Date { 
    func format(_ pattern: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = pattern
        return dateFormatter.string(from: self)
    }
}

extension Date {
    // Date에서 Component에 해당되는 값 가져오기
    var year: Int {
        let cal = Calendar.current
        return cal.component(.year, from: self)
    }
    var month: Int {
        let cal = Calendar.current
        return cal.component(.month, from: self)
    }
    var day: Int {
        let cal = Calendar.current
        return cal.component(.day, from: self)
    }
    var hour: Int {
        let cal = Calendar.current
        return cal.component(.hour, from: self)
    }
    var minute: Int {
        let cal = Calendar.current
        return cal.component(.minute, from: self)
    }
}
