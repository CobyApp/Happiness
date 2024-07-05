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
        ScrollView {
            VStack(spacing: 24) {
                PageTitleView()
                
                SetMemoryTypeView(
                    selectedType: self.$memory.type
                )
                
                SetMemoryPhotosView(
                    photos: self.$memory.photos,
                    photosData: self.$memory.photosData,
                    date: self.$memory.date,
                    location: self.$memory.location,
                    title: self.memory.type.description
                )
            }
            .padding(.bottom, 20)
        }
    }
    
    @ViewBuilder
    private func PageTitleView() -> some View {
        HStack {
            Text("일상 기록하기")
                .font(.pretendard(size: 20, weight: .bold))
                .foregroundColor(Color.labelNormal)
            
            Spacer()
        }
        .padding(.top, 8)
        .padding(.horizontal, BaseSize.horizantalPadding)
    }
}
