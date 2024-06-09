//
//  Data+Extensions.swift
//  CobyHappiness
//
//  Created by Coby on 6/9/24.
//

import SwiftUI

extension Data {
    var image: Image? {
        if let uiImage = UIImage(data: self) {
            return Image(uiImage: uiImage)
        } else {
            return nil
        }
    }
}
