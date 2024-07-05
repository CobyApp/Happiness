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
    
    private let setTypeAction: (MemoryType) -> Void
    
    init(
        selectedType: Binding<MemoryType>,
        setTypeAction: @escaping (MemoryType) -> Void
    ) {
        self._selectedType = selectedType
        self.setTypeAction = setTypeAction
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("태그")
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
                        self.setTypeAction(memoryType)
                    }
                }
            }
        }
        .padding(.horizontal, BaseSize.horizantalPadding)
    }
}
