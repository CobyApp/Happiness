//
//  ColorMapper.swift
//  CobyHappiness
//
//  Created by Coby Kim on 7/8/24.
//

import SwiftUI

extension String {
    var toColorType: ColorType {
        switch self {
        case "blue":
            return ColorType.blue
        case "red":
            return ColorType.red
        case "green":
            return ColorType.green
        case "orange":
            return ColorType.orange
        case "redOrange":
            return ColorType.redOrange
        case "lime":
            return ColorType.lime
        case "cyan":
            return ColorType.cyan
        case "lightBlue":
            return ColorType.lightBlue
        case "violet":
            return ColorType.violet
        case "purple":
            return ColorType.purple
        case "pink":
            return ColorType.pink
        default:
            return ColorType.red
        }
    }
}
