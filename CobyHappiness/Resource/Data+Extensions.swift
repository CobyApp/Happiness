//
//  Data+Extensions.swift
//  CobyHappiness
//
//  Created by Coby on 6/12/24.
//

import UIKit

extension Data {
    var image: UIImage? {
        UIImage(data: self)
    }
}
