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
