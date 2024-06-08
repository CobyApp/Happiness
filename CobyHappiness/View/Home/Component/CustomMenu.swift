//
//  CustomMenu.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 10/4/23.
//

import SwiftUI

import CobyDS

struct CustomMenu: View {
    @Binding var currentMenu: EventType
    
    var animation: Namespace.ID
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(EventType.allCases, id: \.self) { menu in
                    Text(menu.id)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(currentMenu != menu ? .black : .white)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .frame(maxWidth: .infinity)
                        .background {
                            if currentMenu == menu {
                                Capsule()
                                    .fill(.black)
                                    .matchedGeometryEffect(id: "MENU", in: animation)
                            }
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                currentMenu = menu
                            }
                        }
                }
            }
            .padding(.horizontal, BaseSize.horizantalPadding)
        }
    }
}
