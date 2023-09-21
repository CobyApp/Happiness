//
//  Main.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 2023/09/21.
//

import SwiftUI
import SwiftData

struct Main: View {
    @Environment(\.modelContext) private var context
    @Query private var items: [Event]
    
    @State private var formType: EventFormType?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { event in
                    ListViewRow(event: event, formType: $formType)
                    .swipeActions {
                        Button(role: .destructive) {
                            deleteItem(event)
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
            }
            .navigationTitle("Calendar Events")
            .sheet(item: $formType) { $0 }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        formType = .new
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.medium)
                    }
                }
            }
        }
    }
    
    func deleteItem(_ item: Event) {
        context.delete(item)
    }
}
