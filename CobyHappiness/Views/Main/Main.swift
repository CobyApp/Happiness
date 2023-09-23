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
    
    @Query(sort: \Paper.date, order: .forward)
    private var papers: [Paper]
    
    @State private var isPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                if let paper = papers.first {
                    ForEach(paper.events) { event in
                        ListViewRow(event: event)
                    }
                }
            }
            .navigationTitle("Calendar Events")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        let paper = Paper()
                        context.insert(paper)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.medium)
                    }
                }
            }
        }
    }
}
