//
//  EditBunchFirstPageView.swift
//  CobyHappiness
//
//  Created by Coby on 7/6/24.
//

import SwiftUI

import CobyDS

struct EditBunchFirstPageView: View {
    
    @Binding private var bunch: BunchModel
    
    private let memories: [MemoryModel]
    
    init(
        bunch: Binding<BunchModel>,
        memories: [MemoryModel]
    ) {
        self._bunch = bunch
        self.memories = memories
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                PageTitleView()
                
                SetBunchMemoriesView(
                    selectedMemories: self.$bunch.memories,
                    memories: self.memories
                )
            }
            .padding(.bottom, 20)
        }
    }
    
    @ViewBuilder
    private func PageTitleView() -> some View {
        HStack {
            Text("일상 뭉치기")
                .font(.pretendard(size: 20, weight: .bold))
                .foregroundColor(Color.labelNormal)
            
            Spacer()
        }
        .padding(.top, 8)
        .padding(.horizontal, BaseSize.horizantalPadding)
    }
}
