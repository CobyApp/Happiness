//
//  EventFormView.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 2023/09/21.
//

import SwiftUI

struct EventFormView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    
    @State private var note = ""
    @StateObject var viewModel: EventFormViewModel
    
    @FocusState private var focus: Bool?
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    TextField("Note", text: $note, axis: .vertical)
                        .focused($focus, equals: true)
                    
                    Section(footer: HStack {
                        Spacer()
                        Button {
                            if viewModel.updating {
                                updateItem(viewModel.event!)
                            } else {
                                let newEvent = Event(date: Date(), note: note)
                                addItem(newEvent)
                            }
                            dismiss()
                        } label: {
                            Text(viewModel.updating ? "Update Event" : "Add Event")
                        }
                        .buttonStyle(.borderedProminent)
                        Spacer()
                    }
                    ) {
                        EmptyView()
                    }
                }
            }
            .navigationTitle(viewModel.updating ? "Update" : "New Event")
            .onAppear {
                focus = true
                note = viewModel.event?.note ?? ""
            }
        }
    }
    
    func addItem(_ item: Event) {
        context.insert(item)
    }
    
    func updateItem(_ item: Event) {
        item.note = note
        try? context.save()
    }
}
