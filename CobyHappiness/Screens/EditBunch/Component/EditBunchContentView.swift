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
    
    @State private var isDisabled: Bool = true
    
    var body: some View {
        ScrollView {
            VStack {
                self.ContentView()
            }
            .background(Color.backgroundNormalNormal)
        }
        .onTapGesture {
            self.closeKeyboard()
        }
        .onAppear {
            self.checkDisabled()
        }
        .onChange(of: [self.bunch.title, self.bunch.note]) {
            self.checkDisabled()
        }
    }
    
    @ViewBuilder
    func ContentView() -> some View {
        VStack(spacing: 20) {
            DatePicker(
                "날짜",
                selection: self.$bunch.date
            )
            
            CBTextFieldView(
                text: self.$bunch.title,
                title: "제목",
                placeholder: "제목을 입력해주세요."
            )
            
            CBTextAreaView(
                text: self.$bunch.note,
                title: "내용",
                placeholder: "내용을 입력해주세요."
            )
        }
        .padding(BaseSize.horizantalPadding)
    }
}
 
extension EditBunchContentView {
    private func checkDisabled() {
        if self.bunch.title == "" || self.bunch.note == "" {
            self.isDisabled = true
        } else {
            self.isDisabled = false
        }
    }
}
