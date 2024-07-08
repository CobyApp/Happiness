//
//  Color+Extensions.swift
//  CobyHappiness
//
//  Created by Coby Kim on 7/8/24.
//

import SwiftUI

import CobyDS

extension Color {
    static var mainColor: Color {
        UserDefaults.standard.string(forKey: "mainColor")?.toColor.color ?? ColorType.red.color
    }
}
