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
    
    @State private var isPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { event in
                    ListViewRow(event: event)
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isPresented = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.medium)
                    }
                }
            }
            .sheet(isPresented: $isPresented) {
                EventFormView()
            }
        }
    }
    
    func deleteItem(_ item: Event) {
        context.delete(item)
    }
}
