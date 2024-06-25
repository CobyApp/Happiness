//
//  EditMemoryContentView.swift
//  CobyHappiness
//
//  Created by Coby on 6/11/24.
//

import SwiftUI

import CobyDS

struct EditMemoryContentView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding var selection: Int
    
    @StateObject private var viewModel: EditMemoryViewModel
    
    @State private var isDisabled: Bool = true
    @State private var memory: MemoryModel
    
    init(
        viewModel: EditMemoryViewModel,
        selection: Binding<Int>,
        memory: Binding<MemoryModel>
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._selection = selection
        self._memory = State(wrappedValue: memory.wrappedValue)
    }
    
    init(
        viewModel: EditMemoryViewModel,
        selection: Binding<Int> = .constant(0),
        memory: MemoryModel
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._selection = selection
        self._memory = State(wrappedValue: memory)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(
                leftSide: .left,
                leftAction: {
                    if self.selection == 1 {
                        self.selection = 0
                    } else {
                        self.dismiss()
                    }
                },
                title: "추억 기록"
            )
            
            ScrollView {
                VStack(spacing: 8) {
                    self.PhotosView()
                    
                    self.ContentView()
                }
            }
            
            Button {
                if !self.isDisabled {
                    self.viewModel.appendMemory(memory: self.memory)
                    self.dismiss()
                }
            } label: {
                Text("추억 만들기")
            }
            .buttonStyle(
                CBButtonStyle(
                    buttonColor: Color.redNormal,
                    disable: self.isDisabled
                )
            )
            .padding(.horizontal, BaseSize.horizantalPadding)
            .padding(.bottom, 20)
        }
        .background(Color.backgroundNormalNormal)
        .onTapGesture {
            self.closeKeyboard()
        }
        .onAppear {
            self.checkDisabled()
        }
        .onChange(of: [self.memory.title, self.memory.note]) {
            self.checkDisabled()
        }
    }
    
    @ViewBuilder
    func PhotosView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach(self.memory.photos.compactMap { UIImage(data: $0) }, id: \.self) { image in
                    ThumbnailView(image: image)
                        .frame(width: 80, height: 80)
                }
            }
            .padding(.horizontal, BaseSize.horizantalPadding)
            .padding(.vertical, 12)
        }
    }
    
    @ViewBuilder
    func ContentView() -> some View {
        VStack(spacing: 20) {
            CBTextFieldView(
                text: self.$memory.title,
                title: "제목",
                placeholder: "제목을 입력해주세요."
            )
            
            CBTextAreaView(
                text: self.$memory.note,
                title: "내용",
                placeholder: "내용을 입력해주세요."
            )
        }
        .padding(.horizontal, BaseSize.horizantalPadding)
    }
}
 
extension EditMemoryContentView {
    private func checkDisabled() {
        if self.memory.title == "" || self.memory.note == "" {
            self.isDisabled = true
        } else {
            self.isDisabled = false
        }
    }
}
