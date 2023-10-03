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

// MARK: ScaledButton Style
struct ScaledButtonStyle: ButtonStyle{
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}

// Safe Area Value
extension View {
    func safeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else{
            return .zero
        }
        
        return safeArea
    }
    
    // MARK: ScrollView Offset
    func offset(offset: Binding<CGFloat>) -> some View {
        return self
            .overlay {
                GeometryReader{proxy in
                    let minY = proxy.frame(in: .named("SCROLL")).minY
                    
                    Color.clear
                        .preference(key: OffsetKey.self, value: minY)
                }
                .onPreferenceChange(OffsetKey.self) { value in
                    offset.wrappedValue = value
                }
            }
    }
}

// MARK: Offset Key
struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
