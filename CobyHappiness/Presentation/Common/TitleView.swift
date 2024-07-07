//
//  TitleView.swift
//  CobyHappiness
//
//  Created by Coby on 7/8/24.
//

import SwiftUI

import CobyDS

struct TitleView: View {
    
    private let title: String
    
    init(
        title: String
    ) {
        self.title = title
    }
    
    var body: some View {
        HStack {
            Text(self.title)
                .font(.pretendard(size: 20, weight: .bold))
                .foregroundColor(Color.labelNormal)
            
            Spacer()
        }
        .padding(.top, 8)
        .padding(.horizontal, BaseSize.horizantalPadding)
    }
}
