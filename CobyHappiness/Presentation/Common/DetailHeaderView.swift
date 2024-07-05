//
//  DetailHeaderView.swift
//  CobyHappiness
//
//  Created by Coby on 7/5/24.
//

import SwiftUI

import CobyDS

struct DetailHeaderView: View {
    
    private let isDown: Bool
    private let backAction: () -> Void
    private let optionAction: () -> Void
    
    init(
        isDown: Bool,
        backAction: @escaping () -> Void,
        optionAction: @escaping () -> Void
    ) {
        self.isDown = isDown
        self.backAction = backAction
        self.optionAction = optionAction
    }
    
    var body: some View {
        HStack {
            Button {
                self.backAction()
            } label: {
                Image(uiImage: UIImage.icBack)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(self.isDown ? Color.inverseLabel : Color.labelNeutral)
                    .padding(8)
                    .background(self.isDown ? Color.inverseBackground.opacity(0.7) : Color.backgroundNormalAlternative.opacity(0.7))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            Button {
                self.optionAction()
            } label: {
                Image(uiImage: UIImage.icMore)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(self.isDown ? Color.inverseLabel : Color.labelNeutral)
                    .padding(8)
                    .background(self.isDown ? Color.inverseBackground.opacity(0.7) : Color.backgroundNormalAlternative.opacity(0.7))
                    .clipShape(Circle())
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, BaseSize.horizantalPadding)
        .padding(.top, BaseSize.topAreaPadding + 10)
    }
}
