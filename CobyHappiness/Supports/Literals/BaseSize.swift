//
//  BaseSize.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 2023/09/26.
//

import SwiftUI

enum BaseSize {
    static let horizantalPadding: CGFloat = 20
    static let verticalPadding: CGFloat = 20
    static let fullWidth: CGFloat = UIScreen.main.bounds.size.width - horizantalPadding * 2
    static let fullHeight: CGFloat = fullWidth * 1.2
}
