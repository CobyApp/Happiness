//
//  EmptyMemoryView.swift
//  CobyHappiness
//
//  Created by Coby on 6/22/24.
//

import SwiftUI

import CobyDS

struct EmptyMemoryView: View {
    
    private let buttonAction: () -> Void
    
    init(
        buttonAction: @escaping () -> Void
    ) {
        self.buttonAction = buttonAction
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            
            Text("행복한 추억을 남겨주세요.")
                .font(.pretendard(size: 16, weight: .regular))
                .foregroundStyle(Color.labelNormal)
            
            Button {
                self.buttonAction()
            } label: {
                Text("추억 만들기")
            }
            .buttonStyle(
                CBButtonStyle(
                    buttonSize: .small,
                    buttonColor: Color.redNormal
                )
            )
            .frame(width: 100)
            
            Spacer()
        }
    }
}

#Preview {
    EmptyMemoryView { }
}
