//
//  EditBunchSecondPageView.swift
//  CobyHappiness
//
//  Created by Coby on 7/6/24.
//

import SwiftUI

import CobyDS

struct EditBunchSecondPageView: View {
    
    @Binding private var bunch: BunchModel
    
    init(
        bunch: Binding<BunchModel>
    ) {
        self._bunch = bunch
    }
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                SetBunchImageView(
                    image: self.$bunch.image
                )
                
                CBTextFieldView(
                    text: self.$bunch.title,
                    title: "제목",
                    placeholder: "제목을 입력해주세요."
                )
                .padding(.horizontal, BaseSize.horizantalPadding)
            }
            .padding(.bottom, 20)
        }
    }
}
