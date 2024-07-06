//
//  SetMemoryTypeView.swift
//  CobyHappiness
//
//  Created by Coby on 7/6/24.
//

import SwiftUI

import CobyDS

struct SetMemoryTypeView: View {
    
    @Binding private var selectedType: MemoryType
    
    init(
        selectedType: Binding<MemoryType>
    ) {
        self._selectedType = selectedType
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("일상 태그를 선택해주세요.")
                    .font(.pretendard(size: 16, weight: .regular))
                    .foregroundColor(Color.labelNormal)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, minHeight: 32)
            
            FlexibleStack(spacing: 8) {
                ForEach(MemoryType.allCases) { memoryType in
                    TagView(
                        isSelected: self.selectedType == memoryType,
                        title: memoryType.title
                    )
                    .onTapGesture {
                        self.selectedType = memoryType
                    }
                }
            }
        }
        .padding(.horizontal, BaseSize.horizantalPadding)
    }
}
