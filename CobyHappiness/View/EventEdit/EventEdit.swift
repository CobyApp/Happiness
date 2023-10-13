//
//  EventEdit.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 10/3/23.
//

import SwiftUI
import MapKit
import PhotosUI

struct EventEdit: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var type: EventType
    @State private var date: Date
    @State private var title: String
    @State private var note: String
    @State private var lat: Double?
    @State private var lon: Double?
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    private var event: Event?
    
    init() {
        self._date = State(initialValue: Date())
        self._type = State(initialValue: EventType.moment)
        self._title = State(initialValue: "")
        self._note = State(initialValue: "")
    }
    
    init(event: Event) {
        self.event = event
        self._date = State(initialValue: event.date)
        self._type = State(initialValue: event.type)
        self._title = State(initialValue: event.title)
        self._note = State(initialValue: event.note)
        self._lat = State(initialValue: event.lat)
        self._lon = State(initialValue: event.lon)
        self._selectedImageData = State(initialValue: event.photo)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                EventEditView()
                
                EventContentView()
                
                Button {
                    storeEvent()
                } label: {
                    Text("저장")
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .onTapGesture {
            closeKeyboard()
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
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Text("Select a photo")
            }
            .onChange(of: selectedItem) {
                setPhoto()
            }
        }
        .padding(BaseSize.horizantalPadding)
    }
    
    @ViewBuilder
    func EventContentView() -> some View {
        VStack(spacing: 10) {
            if let selectedImageData,
               let uiImage = UIImage(data: selectedImageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: BaseSize.cardWidth, height: BaseSize.cardWidth * 1.2)
                    .clipShape(.rect(cornerRadius: 15))
                    .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 5)
            }
            
            if let lat = lat, let lon = lon {
                MapView(placeName: title, location: CLLocationCoordinate2D(latitude: lat, longitude: lon))
                    .frame(width: BaseSize.cardWidth, height: BaseSize.cardWidth * 0.7)
                    .clipShape(.rect(cornerRadius: 15))
                    .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 5)
            }
        }
    }
    
    private func storeEvent() {
        if let event, let data = selectedImageData {
            event.date = date
            event.type = type
            event.title = title
            event.note = note
            event.photo = data
            event.lat = lat
            event.lon = lon
            try? context.save()
        } else {
            if let data = selectedImageData {
                let item = Event(
                    date: date,
                    type: type,
                    title: title,
                    note: note,
                    photo: data,
                    lat: lat,
                    lon: lon
                )
                context.insert(item)
            }
        }

        dismiss()
    }
    
    private func setPhoto() {
        Task {
            if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                if let originalImage = UIImage(data: data) {
                    if let compressedImageData = compressImage(originalImage) {
                        selectedImageData = compressedImageData
                    }
                }
            }
            
            if let localID = selectedItem?.itemIdentifier {
                let result = PHAsset.fetchAssets(withLocalIdentifiers: [localID], options: nil)
                
                if let asset = result.firstObject {
                    date = asset.creationDate ?? Date()
                    
                    if let location = asset.location?.coordinate {
                        lat = location.latitude
                        lon = location.longitude
                    }
                }
            }
        }
    }
    
    private func compressImage(_ image: UIImage) -> Data? {
        let newSize = CGSize(width: image.size.width * 0.5, height: image.size.height * 0.5)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let compressedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if let compressedImageData = compressedImage?.jpegData(compressionQuality: 0.5) {
            return compressedImageData
        } else {
            return nil
        }
    }
}
