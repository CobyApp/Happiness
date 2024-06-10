//
//  MapView.swift
//  CobyHappiness
//
//  Created by Coby on 6/9/24.
//

import SwiftUI
import SwiftData

import CobyDS

struct MapView: View {
    
    @Query
    private var events: [Event]
    
    @State private var isPresented: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(
                leftSide: .text,
                leftTitle: "지도",
                rightSide: .icon,
                rightIcon: Image("plus"),
                rightAction: {
                    self.isPresented = true
                }
            )
            
            MapRepresentableView(
                events: self.events
            )
        }
        .background(Color.backgroundNormalNormal)
        .fullScreenCover(isPresented: self.$isPresented) {
            EditView()
        }
    }
}
