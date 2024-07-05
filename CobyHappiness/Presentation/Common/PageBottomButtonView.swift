//
//  PageBottomButtonView.swift
//  CobyHappiness
//
//  Created by Coby on 7/6/24.
//

import SwiftUI

import CobyDS

struct PageBottomButtonView: View {
    
    @Binding private var selection: PageType
    
    private let isDisabled: Bool
    private let buttonAction: () -> Void
    
    init(
        selection: Binding<PageType>,
        isDisabled: Bool,
        buttonAction: @escaping () -> Void
    ) {
        self._selection = selection
        self.isDisabled = isDisabled
        self.buttonAction = buttonAction
    }
    
    var body: some View {
        Group {
            switch self.selection {
            case .first:
                Button {
                    self.buttonAction()
                } label: {
                    Text("다음")
                }
                .buttonStyle(
                    CBButtonStyle(
                        isDisabled: self.isDisabled,
                        buttonColor: Color.redNormal
                    )
                )
            case .second:
                HStack(spacing: 8) {
                    Button {
                        self.selection = .first
                    } label: {
                        Text("이전")
                    }
                    .buttonStyle(
                        CBButtonStyle(
                            buttonType: .outlined,
                            buttonColor: Color.backgroundNormalNormal
                        )
                    )
                    .frame(width: 100)
                    
                    Button {
                        self.buttonAction()
                    } label: {
                        Text("완료")
                    }
                    .buttonStyle(
                        CBButtonStyle(
                            isDisabled: self.isDisabled,
                            buttonColor: Color.redNormal
                        )
                    )
                }
            }
        }
        .padding(.horizontal, BaseSize.horizantalPadding)
        .padding(.bottom, 20)
    }
}

#Preview {
    PageBottomButtonView(
        selection: .constant(.second),
        isDisabled: false
    ) {
        print("끝")
    }
}
