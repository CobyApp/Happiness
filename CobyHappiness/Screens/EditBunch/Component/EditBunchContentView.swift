//
//  EditBunchContentView.swift
//  CobyHappiness
//
//  Created by Coby on 6/16/24.
//

import SwiftUI

import CobyDS

struct EditBunchContentView: View {
    
    @Binding var selection: Int
    @Binding var bunch: Bunch
    
    var body: some View {
        VStack {
            CBTextFieldView(
                text: self.$bunch.title,
                title: "제목",
                placeholder: "제목을 입력해주세요."
            )
            
            Spacer()
        }
        .padding(BaseSize.horizantalPadding)
        .background(Color.backgroundNormalNormal)
        .onTapGesture {
            self.closeKeyboard()
        }
    }
}
