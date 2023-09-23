//
//  ListViewRow.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 2023/09/21.
//

import SwiftUI

struct ListViewRow: View {
    @State private var isPresented: Bool = false
    
    private var event: Event
    
    init(event: Event) {
        self.event = event
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(event.type.icon)
                        .font(.system(size: 40))
                    
                    Text(event.note)
                        .font(.bmjua())
                }
            }
            
            Spacer()
            
            Button {
                isPresented = true
            } label: {
                Text("Edit")
            }
            .buttonStyle(.bordered)
        }
        .sheet(isPresented: $isPresented) {
            EventEdit(event: event)
        }
    }
}
