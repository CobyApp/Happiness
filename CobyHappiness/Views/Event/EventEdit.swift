//
//  EventEdit.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 2023/09/21.
//

import SwiftUI

struct EventEdit: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var type: EventType
    @State private var note: String
    
    @FocusState private var focus: Bool?
    
    private var event: Event
    
    init(event: Event) {
        self.event = event
        self._type = State(wrappedValue: event.type)
        self._note = State(wrappedValue: event.note)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    TextField("Note", text: $note, axis: .vertical)
                        .focused($focus, equals: true)
                    
                    Section(footer: HStack {
                        Spacer()
                        Button {
                            event.type = type
                            event.note = note
                            try? context.save()
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
            .onAppear {
                focus = true
            }
        }
    }
}
