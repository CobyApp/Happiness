//
//  TravelView.swift
//  CobyHappiness
//
//  Created by Coby on 6/9/24.
//

import SwiftUI

import CobyDS

struct TravelView: View {
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(
                leftSide: .text,
                leftTitle: "여행",
                rightSide: .icon,
                rightIcon: Image("add"),
                rightAction: {
                    print("추가")
                }
            )
            
            Spacer()
        }
        .background(Color.backgroundNormalNormal)
        .loadCustomFonts()
    }
}
