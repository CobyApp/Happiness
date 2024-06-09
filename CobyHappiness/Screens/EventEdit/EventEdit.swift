//
//  EventEdit.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 10/3/23.
//

import SwiftUI
import MapKit
import PhotosUI

import CobyDS

struct EventEdit: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var type: EventType = EventType.moment
    @State private var date: Date = Date()
    @State private var title: String = ""
    @State private var note: String = ""
    @State private var photos: [Photo] = []
    
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var isDisabled: Bool = true
    
    private var event: Event?
    
    init() {}
    
    init(event: Event) {
        self.event = event
        self._date = State(initialValue: event.date)
        self._type = State(initialValue: event.type)
        self._title = State(initialValue: event.title)
        self._note = State(initialValue: event.note)
        self._photos = State(initialValue: event.photos)
        self._isDisabled = State(initialValue: event.photos.isEmpty)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                EventEditView()
                
                EventContentView()
                
                Text(NSLocalizedString("추억 저장하기", comment: ""))
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 58)
                    .background(isDisabled ? Color.interactionDisable : Color.redNormal)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal, BaseSize.horizantalPadding)
                    .onTapGesture {
                        if !isDisabled {
                            storeEvent()
                        }
                    }
            }
        }
        .onTapGesture {
            closeKeyboard()
        }
        .onChange(of: photos) {
            date = photos.first?.date ?? Date()
            checkDisabled()
        }
        .onChange(of: title) {
            checkDisabled()
        }
        .onChange(of: note) {
            checkDisabled()
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
                ForEach(photos) { photo in
                    if let uiImage = UIImage(data: photo.image) {
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
            photos = []
            
            for item in selectedItems {
                var image: Data?
                
                if let data = try? await item.loadTransferable(type: Data.self) {
                    if let originalImage = UIImage(data: data) {
                        if let compressedImageData = compressImage(originalImage) {
                            image = compressedImageData
                        }
                    }
                }
                
                if let localID = item.itemIdentifier {
                    let result = PHAsset.fetchAssets(withLocalIdentifiers: [localID], options: nil)
                    
                    if let asset = result.firstObject {
                        if let date = asset.creationDate, let image = image {
                            photos.append(Photo(date: date, image: image))
                            
                            if let location = asset.location?.coordinate {
                                photos.last?.lat = location.latitude
                                photos.last?.lon = location.longitude
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func storeEvent() {
        if let event {
            event.date = date
            event.type = type
            event.title = title
            event.note = note
            event.photos = photos
            try? context.save()
        } else {
            let item = Event(
                date: date,
                type: type,
                title: title,
                note: note,
                photos: photos
            )
            context.insert(item)
        }

        dismiss()
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
        if title == "" || note == "" || photos.isEmpty {
            isDisabled = true
        } else {
            isDisabled = false
        }
    }
}
