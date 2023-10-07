//
//  EventEdit.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 10/3/23.
//

import SwiftUI
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
        NavigationStack {
            VStack {
                Form {
                    DatePicker("Please enter a date", selection: $date)
                    
                    Picker("Event Type", selection: $type) {
                        ForEach(EventType.allCases) { eventType in
                            Text(eventType.icon + " " + eventType.id.capitalized)
                                .tag(eventType)
                        }
                    }
                    
                    TextField("Title", text: $title, axis: .vertical)
                    
                    TextField("Note", text: $note, axis: .vertical)
                    
                    if let selectedImageData,
                       let uiImage = UIImage(data: selectedImageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 250, height: 250)
                            .clipped()
                    }
                    
                    Section(footer: HStack {
                        PhotosPicker(
                            selection: $selectedItem,
                            matching: .images,
                            photoLibrary: .shared()
                        ) {
                            Text("Select a photo")
                        }
                        .onChange(of: selectedItem) {
                            Task {
                                if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                                    selectedImageData = data
                                }
                                
                                if let localID = selectedItem?.itemIdentifier {
                                    let result = PHAsset.fetchAssets(withLocalIdentifiers: [localID], options: nil)
                                    
                                    if let asset = result.firstObject {
                                        print("Got " + asset.debugDescription)
                                        date = asset.creationDate ?? Date()
                                        
                                        if let location = asset.location?.coordinate {
                                            lat = location.latitude
                                            lon = location.longitude
                                        }
                                    }
                                }
                            }
                        }

                        Spacer()
                        
                        Button {
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
                        } label: {
                            Text("Update Event")
                        }
                        .buttonStyle(.borderedProminent)
                        Spacer()
                    }
                    ) {
                        EmptyView()
                    }
                }
            }
            .navigationTitle("Update")
            .onTapGesture {
                closeKeyboard()
            }
        }
    }
}
