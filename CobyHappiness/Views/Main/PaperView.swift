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
        VStack(alignment: .leading) {
            Text(paper.date.format("yyyy년 MM월 dd일"))
                .font(.bmjua())
            
            ScrollView(showsIndicators: false) {
                VStack {
                    ForEach(paper.events) { event in
                        EventViewRow(event: event)
                    }
                }
            }
        }
        .padding(.horizontal, BaseSize.horizantalPadding)
        .padding(.vertical, BaseSize.verticalPadding)
        .background(Color.backgroundSecondary)
    }
}
