//
//  ColorType.swift
//  CobyHappiness
//
//  Created by Coby Kim on 7/8/24.
//

import SwiftUI

import CobyDS

enum ColorType: String, Equatable, CaseIterable {
    case blue
    case red
    case green
    case orange
    case redOrange
    case lime
    case cyan
    case lightBlue
    case violet
    case purple
    case pink
    
    var color: Color {
        switch self {
        case .blue:
            return Color.blueNormal
        case .red:
            return Color.redNormal
        case .green:
            return Color.greenNormal
        case .orange:
            return Color.orangeNormal
        case .redOrange:
            return Color.redOrangeNormal
        case .lime:
            return Color.limeNormal
        case .cyan:
            return Color.cyanNormal
        case .lightBlue:
            return Color.lightBlueNormal
        case .violet:
            return Color.violetNormal
        case .purple:
            return Color.purpleNormal
        case .pink:
            return Color.pinkNormal
        }
    }
}
