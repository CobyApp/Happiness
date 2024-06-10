//
//  EditEventView.swift
//  CobyHappiness
//
//  Created by Coby on 6/11/24.
//

import SwiftUI

import CobyDS

struct EditEventView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @Binding var selectionMade: Bool
    @Binding var selectedImages: [UIImage]
    @Binding var date: Date
    @Binding var location: Location?
    
    @State private var type: EventType = EventType.moment
    @State private var title: String = ""
    @State private var note: String = ""
    
    @State private var isDisabled: Bool = true
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(
                leftSide: .left,
                leftAction: {
                    self.selectionMade = false
                },
                title: "추억 만들기"
            )
            
            ScrollView {
                VStack {
                    self.PhotosView()
                    
                    self.ContentView()
                    
                    Text(NSLocalizedString("저장", comment: ""))
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 58)
                        .background(self.isDisabled ? Color.interactionDisable : Color.redNormal)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.horizontal, BaseSize.horizantalPadding)
                        .onTapGesture {
                            if !self.isDisabled {
                                self.storeEvent()
                            }
                        }
                }
            }
        }
        .background(Color.backgroundNormalNormal)
        .onTapGesture {
            self.closeKeyboard()
        }
        .onChange(of: [self.title, self.note]) {
            self.checkDisabled()
        }
    }
    
    @ViewBuilder
    func PhotosView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(self.selectedImages, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 240)
                        .clipShape(.rect(cornerRadius: 15))
                }
            }
            .padding(.horizontal, BaseSize.horizantalPadding)
        }
    }
    
    @ViewBuilder
    func ContentView() -> some View {
        VStack(spacing: 4) {
            DatePicker("날짜", selection: $date)
            
            Picker("분야", selection: $type) {
                ForEach(EventType.allCases) { eventType in
                    Text(eventType.icon + " " + eventType.id.capitalized)
                        .tag(eventType)
                }
            }
            
            CBTextFieldView(
                text: self.$title,
                title: "제목",
                placeholder: "제목을 입력해주세요."
            )
            
            CBTextFieldView(
                text: self.$note,
                title: "내용",
                placeholder: "내용을 입력해주세요."
            )
        }
        .padding(BaseSize.horizantalPadding)
    }
    
    private func storeEvent() {
        do {
            let item = Event(
                date: self.date,
                type: self.type,
                title: self.title,
                note: self.note,
                location: self.location,
                photos: self.selectedImages.compactMap { self.compressImage($0) }
            )
            self.context.insert(item)
            try self.context.save()
            
            self.dismiss()
        } catch {
            print("error")
        }
    }
    
    private func checkDisabled() {
        if self.title == "" || self.note == "" {
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
