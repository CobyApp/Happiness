//
//  EventEdit.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 10/3/23.
//

import SwiftUI

struct EventEdit: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var type: EventType
    @State private var title: String
    @State private var note: String
    
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
                    
                    Section(footer: HStack {
                        Spacer()
                        Button {
                            if let event {
                                event.type = type
                                event.title = title
                                event.note = note
                                try? context.save()
                            } else {
                                let item = Event(
                                    date: Date(),
                                    type: type,
                                    title: title,
                                    note: note
                                )
                                print("저긴뎁")
                                print(item)
//                                context.insert(item)
                                print("여긴뎁")
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
