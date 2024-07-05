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
            VStack(spacing: 20) {
                SetMemoryTypeView(
                    selectedType: self.$memory.type
                )
                
                SetMemoryPhotosView(
                    photos: self.$memory.photos,
                    photosData: self.$memory.photosData,
                    date: self.$memory.date,
                    location: self.$memory.location
                )
            }
            .padding(.bottom, 20)
        }
    }
}
