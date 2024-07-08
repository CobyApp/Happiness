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
                textFieldTrailing: .textCount,
                title: "추억에 이름을 만들어주세요.",
                placeholder: "10자 이내로 적어주세요.",
                maxLength: 10
            )
            
            CBTextAreaView(
                text: self.$note,
                title: "어떤 행복한 추억이었나요?",
                placeholder: "내용을 기록해주세요."
            )
        }
        .padding(.horizontal, BaseSize.horizantalPadding)
    }
}
