//
//  EmptyMemoryView.swift
//  CobyHappiness
//
//  Created by Coby on 6/22/24.
//

import SwiftUI

import CobyDS

struct EmptyMemoryView: View {
    
    private let showingButton: Bool
    private let buttonAction: () -> Void
    
    init(
        showingButton: Bool = true,
        buttonAction: @escaping () -> Void = {}
    ) {
        self.showingButton = showingButton
        self.buttonAction = buttonAction
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            
            Text(self.showingButton ? "행복한 추억을 남겨주세요." : "저장된 추억이 없어요.")
                .font(.pretendard(size: 16, weight: .regular))
                .foregroundStyle(Color.labelNormal)
            
            if self.showingButton {
                Button {
                    self.buttonAction()
                } label: {
                    Text("추억 만들기")
                }
                .buttonStyle(
                    CBButtonStyle(
                        buttonSize: .small,
                        buttonColor: Color.mainColor
                    )
                )
                .frame(width: 100)
            }
            
            Spacer()
        }
    }
}

#Preview {
    EmptyMemoryView { }
}
