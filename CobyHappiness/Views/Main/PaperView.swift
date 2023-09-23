//
//  PaperView.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 2023/09/24.
//

import SwiftUI

struct PaperView: View {
    var paper: Paper
    
    var body: some View {
        List {
            Text(paper.date.format("yyyy년 MM월 yy일"))
            
            ForEach(paper.events) { event in
                ListViewRow(event: event)
            }
        }
    }
}
