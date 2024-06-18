//
//  Environment+Extensions.swift
//  CobyHappiness
//
//  Created by Coby on 6/19/24.
//

import SwiftUI

struct AnimationNamespaceKey: EnvironmentKey {
    static let defaultValue: Namespace.ID? = nil
}

extension EnvironmentValues {
    var animationNamespace: Namespace.ID? {
        get { self[AnimationNamespaceKey.self] }
        set { self[AnimationNamespaceKey.self] = newValue }
    }
}
