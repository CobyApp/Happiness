//
//  EditMemoryFirstPageView.swift
//  CobyHappiness
//
//  Created by Coby on 7/6/24.
//

import SwiftUI

import CobyDS

struct EditMemoryFirstPageView: View {
    
    @Binding private var memory: MemoryModel
    
    init(
        memory: Binding<MemoryModel>
    ) {
        self._memory = memory
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                TitleView(title: "추억 기록하기")
                
                SetMemoryTypeView(
                    selectedType: self.$memory.type
                )
                
                SetMemoryPhotosView(
                    photosData: self.$memory.photosData,
                    date: self.$memory.date,
                    location: self.$memory.location,
                    title: self.memory.type.description
                )
            }
            .padding(.bottom,  BaseSize.verticalPadding)
        }
    }
}
