//
//  ListViewRow.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 2023/09/21.
//

import SwiftUI

struct ListViewRow: View {
    let event: Event
    @Binding var formType: EventFormType?
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(
                    event.date.format("yyyy년 MM월 yy일")
                )
                
                Text(event.note)
            }
            
            Spacer()
            
            Button {
                formType = .update(event)
            } label: {
                Text("Edit")
            }
            .buttonStyle(.bordered)
        }
    }
}
