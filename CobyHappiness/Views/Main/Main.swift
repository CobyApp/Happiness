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
    
    @Query(sort: \Paper.date, order: .reverse)
    private var papers: [Paper]
    
    @State private var isPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if let paper = papers.first {
                    PaperView(paper: paper)
                }
            }
            .navigationTitle("행복 리스트")
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
