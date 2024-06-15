//
//  EditMemoryView.swift
//  CobyHappiness
//
//  Created by Coby on 6/11/24.
//

import SwiftUI

import CobyDS

struct EditMemoryView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @Binding var selection: Int

    @State private var memory: Memory
    @State private var isDisabled: Bool = true
    
    init(
        selection: Binding<Int>,
        memory: Memory
    ) {
        self._selection = selection
        self._memory = State(wrappedValue: memory)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(
                leftSide: .left,
                leftAction: {
                    self.selection = 0
                },
                title: "추억 만들기"
            )
            
            ScrollView {
                VStack {
                    self.PhotosView()
                    
                    self.ContentView()
                }
            }
            
            Button {
                self.storeMemory()
            } label: {
                Text("저장")
            }
            .buttonStyle(
                CBButtonStyle(
                    buttonColor: Color.redNormal,
                    disable: self.isDisabled
                )
            )
            .padding(.horizontal, BaseSize.horizantalPadding)
        }
        .background(Color.backgroundNormalNormal)
        .onTapGesture {
            self.closeKeyboard()
        }
        .onChange(of: self.memory) {
            self.checkDisabled()
        }
    }
    
    @ViewBuilder
    func PhotosView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(self.memory.photos.compactMap { UIImage(data: $0) }, id: \.self) { image in
                    ThumbnailView(image: image)
                        .frame(width: 100, height: 100)
                }
            }
            .padding(.horizontal, BaseSize.horizantalPadding)
        }
    }
    
    @ViewBuilder
    func ContentView() -> some View {
        VStack(spacing: 20) {
            DatePicker("날짜", selection: self.$memory.date)
            
            CBTextFieldView(
                text: self.$memory.title,
                title: "제목",
                placeholder: "제목을 입력해주세요."
            )
            
            CBTextFieldView(
                text: self.$memory.note,
                title: "내용",
                placeholder: "내용을 입력해주세요."
            )
        }
        .padding(BaseSize.horizantalPadding)
    }
    
    private func storeMemory() {
        do {
            self.context.insert(self.memory)
            try self.context.save()
            
            self.dismiss()
        } catch {
            print("error")
        }
    }
    
    private func checkDisabled() {
        if self.memory.title == "" || self.memory.note == "" {
            self.isDisabled = true
        } else {
            self.isDisabled = false
        }
    }
    
    private func compressImage(_ image: UIImage) -> Data? {
        let newSize = CGSize(width: image.size.width * 0.3, height: image.size.height * 0.3)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let compressedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if let compressedImageData = compressedImage?.jpegData(compressionQuality: 0.3) {
            return compressedImageData
        } else {
            return nil
        }
    }
}
