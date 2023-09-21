//
//  View+Extensions.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 2023/09/21.
//

import SwiftUI

extension View {
    func closeKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func hAlign(_ alignment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    func vAlign(_ alignment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
}

extension View {
    @ViewBuilder
    func neverCapitalization() -> some View {
        self.textInputAutocapitalization(.never)
    }
    
    @ViewBuilder
    func overlayCompat<V: View>(alignment: Alignment = .center, @ViewBuilder content: () -> V) -> some View {
        self.overlay(alignment: alignment, content: content)
    }
}
