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
    @State private var title: String
    @State private var note: String
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    private var event: Event?
    
    init() {
        self._type = State(initialValue: EventType.moment)
        self._title = State(initialValue: "")
        self._note = State(initialValue: "")
    }
    
    init(event: Event) {
        self.event = event
        self._type = State(initialValue: event.type)
        self._title = State(initialValue: event.title)
        self._note = State(initialValue: event.note)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
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
                            .scaledToFit()
                            .frame(width: 250, height: 250)
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
                            }
                        }

                        Spacer()
                        
                        Button {
                            if let event, let data = selectedImageData {
                                event.type = type
                                event.title = title
                                event.note = note
                                event.photo = data
                                try? context.save()
                            } else {
                                if let data = selectedImageData {
                                    let item = Event(
                                        date: Date(),
                                        type: type,
                                        title: title,
                                        note: note,
                                        photo: data
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
