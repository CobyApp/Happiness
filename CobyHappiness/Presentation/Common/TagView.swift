//
//  TagView.swift
//  CobyHappiness
//
//  Created by Coby on 7/6/24.
//

import SwiftUI

import CobyDS

struct TagView: View {
    
    private let isSelected: Bool
    private let title: String
    
    init(
        isSelected: Bool,
        title: String
    ) {
        self.isSelected = isSelected
        self.title = title
    }
    
    var body: some View {
        Text(self.title)
            .font(.pretendard(size: 14, weight: .regular))
            .foregroundColor(Color.labelNeutral)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(self.isSelected ? Color.fillStrong : Color.backgroundNormalNormal)
            .clipShape(.rect(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.lineNormalNeutral, lineWidth: 1)
            )
    }
}
