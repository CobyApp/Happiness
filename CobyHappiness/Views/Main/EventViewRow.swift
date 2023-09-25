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
        HStack {
            VStack(alignment: .leading) {
                Text(event.type.icon)
                    .font(.system(size: 40))
                
                TextField(event.type.id, text: $note)
                    .textFieldStyle(CommonTextfieldStyle())
            }
            
            Spacer()
        }
        .onChange(of: note) {
            event.note = note
            try? context.save()
        }
    }
}
