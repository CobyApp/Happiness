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
    static let fullWidth: CGFloat = UIScreen.main.bounds.size.width
    static let fullHeight: CGFloat = UIScreen.main.bounds.size.height
    static let cardWidth: CGFloat = UIScreen.main.bounds.size.width - horizantalPadding * 2
    static var topAreaPadding: CGFloat {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        let topPadding = window?.safeAreaInsets.top ?? 0
        return topPadding
    }
    static var bottomAreaPadding: CGFloat {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0
        return bottomPadding
    }
}
