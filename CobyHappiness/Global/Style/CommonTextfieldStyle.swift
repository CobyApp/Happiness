//
//  CommonTextfieldStyle.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 2023/09/25.
//

import SwiftUI

struct CommonTextfieldStyle: TextFieldStyle {
    private var underlinedBackground: some View {
        VStack {
            Spacer()
            Color.borderDefault.frame(height: 1)
        }
    }
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.body)
            .foregroundColor(Color.grayscale100)
            .padding(.vertical, 4)
            .background(underlinedBackground)
    }
}
