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
                    .foregroundColor(self.isDown ? Color.white.opacity(0.8) : Color.black.opacity(0.7))
                    .padding()
                    .background(self.isDown ? Color.black.opacity(0.7) : Color.white.opacity(0.8))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            Button {
                self.optionAction()
            } label: {
                Image(uiImage: UIImage.icMore)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(self.isDown ? Color.white.opacity(0.8) : Color.black.opacity(0.7))
                    .padding()
                    .background(self.isDown ? Color.black.opacity(0.7) : Color.white.opacity(0.8))
                    .clipShape(Circle())
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, BaseSize.horizantalPadding)
        .padding(.top, BaseSize.topAreaPadding + 10)
    }
}
