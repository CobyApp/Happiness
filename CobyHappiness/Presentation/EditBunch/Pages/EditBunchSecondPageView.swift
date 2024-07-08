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
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                SetBunchImageView(
                    image: self.$bunch.image,
                    imageData: self.$bunch.imageData
                )
                
                SetBunchTitleView(
                    title: self.$bunch.title
                )
            }
            .padding(.bottom, BaseSize.verticalPadding)
        }
    }
}
