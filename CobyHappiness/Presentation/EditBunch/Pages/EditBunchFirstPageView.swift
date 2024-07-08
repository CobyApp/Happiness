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
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                TitleView(title: "추억 뭉치기")
                
                SetBunchMemoriesView(
                    selectedMemories: self.$bunch.memories,
                    memories: self.memories
                )
            }
            .padding(.bottom, BaseSize.verticalPadding)
        }
    }
}
