//
//  ListViewRow.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 2023/09/21.
//

import SwiftUI

struct ListViewRow: View {
    @State private var isPresented: Bool = false
    
    var event: Event
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(event.type.icon)
                        .font(.system(size: 40))
                    
                    Text(event.note)
                }
                
                Text(
                    event.date.format("yyyy년 MM월 yy일")
                )
            }
            
            Spacer()
            
            Button {
                isPresented = true
            } label: {
                Text("Edit")
            }
            .buttonStyle(.bordered)
        }
    }
}
