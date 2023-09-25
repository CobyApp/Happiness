//
//  EventViewRow.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 2023/09/21.
//

import SwiftUI

struct EventViewRow: View {
    @Environment(\.modelContext) private var context
    
    @State private var note: String
    
    private var event: Event
    
    init(event: Event) {
        self.event = event
        self._note = State(wrappedValue: event.note)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(event.type.id)
                .font(.headline)
            
            TextField(event.type.description, text: $note)
                .textFieldStyle(CommonTextfieldStyle())
        }
        .onChange(of: note) {
            event.note = note
            try? context.save()
        }
    }
}
