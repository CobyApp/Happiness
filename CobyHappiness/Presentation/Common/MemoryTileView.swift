//
//  MemoryTileView.swift
//  CobyHappiness
//
//  Created by Coby on 6/12/24.
//

import SwiftUI

import CobyDS

struct MemoryTileView: View {
    
    private let memory: MemoryModel
    private let isSelected: Bool
    
    init(
        memory: MemoryModel,
        isSelected: Bool = false
    ) {
        self.memory = memory
        self.isSelected = isSelected
    }
    
    var body: some View {
        HStack(spacing: 12) {
            ThumbnailView(
                image: self.memory.photos.first
            )
            .frame(width: 80, height: 80)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(self.memory.title)
                        .font(.pretendard(size: 16, weight: .medium))
                        .foregroundColor(Color.labelNormal)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Spacer()
                    
                    Text(self.memory.date.format("yy년 MM월 dd일"))
                        .font(.pretendard(size: 12, weight: .regular))
                        .foregroundColor(Color.labelAlternative)
                        .minimumScaleFactor(1)
                }
                
                Text(self.memory.note)
                    .font(.pretendard(size: 14, weight: .regular))
                    .foregroundColor(Color.labelNeutral)
                    .lineLimit(2)
                    .truncationMode(.tail)
                
                Spacer()
            }
            .padding(4)
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .background(Color.backgroundNormalNormal)
        .clipShape(.rect(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(self.isSelected ? Color.blueNormal : Color.lineNormalNeutral, lineWidth: 1)
        )
    }
}
