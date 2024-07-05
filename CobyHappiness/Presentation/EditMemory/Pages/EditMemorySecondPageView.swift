//
//  EditMemorySecondPageView.swift
//  CobyHappiness
//
//  Created by Coby on 7/6/24.
//

import SwiftUI

import CobyDS

struct EditMemorySecondPageView: View {
    
    @Binding private var memory: MemoryModel
    
    init(
        memory: Binding<MemoryModel>
    ) {
        self._memory = memory
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                SetMemoryContentView(
                    title: self.$memory.title,
                    note: self.$memory.note
                )
            }
            .padding(.bottom, 20)
        }
    }
}
