//
//  EditView.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 10/3/23.
//

import SwiftUI
import PhotosUI

import CobyDS

struct EditView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var type: EventType = EventType.moment
    @State private var date: Date = Date()
    @State private var title: String = ""
    @State private var note: String = ""
    @State private var location: Location?
    @State private var photos: [Data] = []
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var isDisabled: Bool = true
    
    private var event: Event?
    private let screenTitle: String
    
    init() {
        self.screenTitle = "추억 만들기"
    }
    
    init(event: Event) {
        self.event = event
        self.screenTitle = "추억 수정하기"
        self._date = State(initialValue: event.date)
        self._type = State(initialValue: event.type)
        self._title = State(initialValue: event.title)
        self._note = State(initialValue: event.note)
        self._photos = State(initialValue: event.photos)
        self._isDisabled = State(initialValue: event.photos.isEmpty)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(
                leftSide: .left,
                leftAction: {
                    self.dismiss()
                },
                title: self.screenTitle
            )
            
            ScrollView {
                VStack {
                    self.EventEditView()
                    
                    self.EventContentView()
                    
                    Text(NSLocalizedString("추억 저장하기", comment: ""))
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
        .onTapGesture {
            self.closeKeyboard()
        }
        .onChange(of: self.photos) {
            self.checkDisabled()
        }
        .onChange(of: [self.title, self.note]) {
            self.checkDisabled()
        }
    }
    
    @ViewBuilder
    func EventEditView() -> some View {
        VStack(spacing: 4) {
            DatePicker("날짜", selection: $date)
            
            Picker("분야", selection: $type) {
                ForEach(EventType.allCases) { eventType in
                    Text(eventType.icon + " " + eventType.id.capitalized)
                        .tag(eventType)
                }
            }
            
            TextField("제목", text: $title, axis: .vertical)
            
            TextField("내용", text: $note, axis: .vertical)
            
            PhotosPicker(
                selection: $selectedItems,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Text("Pick Photo")
            }
            .onChange(of: selectedItems) {
                setupPhotos()
            }
        }
        .padding(BaseSize.horizantalPadding)
    }
    
    @ViewBuilder
    func EventContentView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(self.photos, id: \.self) { photo in
                    if let uiImage = UIImage(data: photo) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 240)
                            .clipShape(.rect(cornerRadius: 15))
                    }
                }
            }
            .padding(.horizontal, BaseSize.horizantalPadding)
        }
    }
    
    private func setupPhotos() {
        Task {
            self.photos = []
            
            for item in self.selectedItems {
                var image: Data?
                
                if let data = try? await item.loadTransferable(type: Data.self) {
                    if let originalImage = UIImage(data: data) {
                        if let compressedImageData = self.compressImage(originalImage) {
                            image = compressedImageData
                        }
                    }
                }
                
                if let localID = item.itemIdentifier {
                    let result = PHAsset.fetchAssets(withLocalIdentifiers: [localID], options: nil)
                    
                    if let asset = result.firstObject {
                        if let date = asset.creationDate, let image = image {
                            self.date = date
                            self.photos.append(image)
                            
                            if let location = asset.location?.coordinate {
                                self.location = Location(lat: location.latitude, lon: location.longitude)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func storeEvent() {
        do {
            if let event = event {
                let item = Event(
                    id: event.id,
                    date: self.date,
                    type: self.type,
                    title: self.title,
                    note: self.note,
                    location: self.location,
                    photos: self.photos
                )
                self.context.insert(item)
                try self.context.save()
            } else {
                let item = Event(
                    date: self.date,
                    type: self.type,
                    title: self.title,
                    note: self.note,
                    location: self.location,
                    photos: self.photos
                )
                self.context.insert(item)
                try self.context.save()
            }
            
            self.dismiss()
        } catch {
            print("error")
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
    
    private func checkDisabled() {
        if self.title == "" || self.note == "" || self.photos.isEmpty {
            self.isDisabled = true
        } else {
            self.isDisabled = false
        }
    }
}
