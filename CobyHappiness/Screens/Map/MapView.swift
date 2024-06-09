//
//  MapView.swift
//  CobyHappiness
//
//  Created by Coby on 6/9/24.
//

import SwiftUI
import MapKit

import CobyDS

struct MapView: View {
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(
                leftSide: .text,
                leftTitle: "지도",
                rightSide: .icon,
                rightIcon: Image("plus"),
                rightAction: {
                    print("추가")
                }
            )
            
            Map()
        }
        .background(Color.backgroundNormalNormal)
    }
}
