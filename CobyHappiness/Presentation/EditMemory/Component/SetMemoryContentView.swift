//
//  SetMemoryContentView.swift
//  CobyHappiness
//
//  Created by Coby on 7/6/24.
//

import SwiftUI

import CobyDS

struct SetMemoryContentView: View {
    
    @Binding private var title: String
    @Binding private var note: String
    
    init(
        title: Binding<String>,
        note: Binding<String>
    ) {
        self._title = title
        self._note = note
    }
    
    var body: some View {
        VStack(spacing: 24) {
            CBTextFieldView(
                text: self.$title,
                title: "제목",
                placeholder: "제목을 입력해주세요."
            )
            
            CBTextAreaView(
                text: self.$note,
                title: "내용",
                placeholder: "내용을 입력해주세요."
            )
        }
        .padding(.horizontal, BaseSize.horizantalPadding)
    }
}
