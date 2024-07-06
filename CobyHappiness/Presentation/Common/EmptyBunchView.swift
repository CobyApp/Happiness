//
//  EmptyBunchView.swift
//  CobyHappiness
//
//  Created by Coby on 6/22/24.
//

import SwiftUI

import CobyDS

struct EmptyBunchView: View {
    
    private let buttonAction: () -> Void
    
    init(
        buttonAction: @escaping () -> Void
    ) {
        self.buttonAction = buttonAction
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            
            Text("추억을 모아 뭉치로 만들어보세요.")
                .font(.pretendard(size: 16, weight: .regular))
                .foregroundStyle(Color.labelNormal)
            
            Button {
                self.buttonAction()
            } label: {
                Text("뭉치 만들기")
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
    EmptyBunchView { }
}
