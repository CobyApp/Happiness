//
//  PaperView.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 2023/09/24.
//

import SwiftUI

struct PaperView: View {
    private var paper: Paper
    
    init(paper: Paper) {
        self.paper = paper
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text(paper.date.format("MMM d, yyyy"))
                .font(.title3)
            
            LazyVStack(spacing: 24) {
                ForEach(paper.events.sorted(by: { $0.type.id > $1.type.id })) { event in
                    EventViewRow(event: event)
                }
            }
        }
        .padding(.horizontal, BaseSize.horizantalPadding)
        .padding(.vertical, BaseSize.verticalPadding)
        .background(Color.backgroundSecondary)
        .frame(width: BaseSize.fullWidth)
        .cornerRadius(25)
    }
}
