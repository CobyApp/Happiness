////
////  EventFormView.swift
////  CobyHappiness
////
////  Created by COBY_PRO on 2023/09/21.
////
//
//import SwiftUI
//
//struct EventFormView: View {
//    @Environment(\.modelContext) private var context
//    @Environment(\.dismiss) private var dismiss
//    
//    @State private var type: EventType = .unspecified
//    @State private var note: String = ""
//    
//    private var updating: Bool = false
//    private var event: Event?
//    
//    @FocusState private var focus: Bool?
//    
//    init() { }
//    
//    init(event: Event) {
//        self.updating = true
//        self.event = event
//        self._type = State(wrappedValue: event.type)
//        self._note = State(wrappedValue: event.note)
//    }
//    
//    var body: some View {
//        NavigationStack {
//            VStack {
//                Form {
//                    TextField("Note", text: $note, axis: .vertical)
//                        .focused($focus, equals: true)
//                    
//                    Picker("Event Type", selection: $type) {
//                        ForEach(EventType.allCases) { eventType in
//                            Text(eventType.icon + " " + eventType.rawValue.capitalized)
//                                .tag(eventType)
//                        }
//                    }
//                    
//                    Section(footer: HStack {
//                        Spacer()
//                        Button {
//                            if let event {
//                                event.type = type
//                                event.note = note
//                                try? context.save()
//                            } else {
//                                let item = Event(type: type , date: Date(), note: note)
//                                context.insert(item)
//                            }
//                            dismiss()
//                        } label: {
//                            Text(updating ? "Update Event" : "Add Event")
//                        }
//                        .buttonStyle(.borderedProminent)
//                        Spacer()
//                    }
//                    ) {
//                        EmptyView()
//                    }
//                }
//            }
//            .navigationTitle(updating ? "Update" : "New Event")
//            .onAppear {
//                focus = true
//            }
//        }
//    }
//}
