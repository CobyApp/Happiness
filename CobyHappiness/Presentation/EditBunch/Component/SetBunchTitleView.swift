//
//  SetBunchTitleView.swift
//  CobyHappiness
//
//  Created by Coby on 7/8/24.
//

import SwiftUI

import CobyDS

struct SetBunchTitleView: View {
    
    @Binding private var title: String
    
    init(
        title: Binding<String>
    ) {
        self._title = title
    }
    
    var body: some View {
        CBTextFieldView(
            text: self.$title,
            title: "추억 뭉치의 이름을 정해주세요.",
            placeholder: "10자 이내로 적어주세요.",
            maxLength: 10
        )
        .padding(.horizontal, BaseSize.horizantalPadding)
    }
}
