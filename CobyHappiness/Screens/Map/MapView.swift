//
//  MapView.swift
//  CobyHappiness
//
//  Created by Coby on 6/9/24.
//

import SwiftUI
import SwiftData
import MapKit

import CobyDS

struct MapView: View {
    
    @Query
    private var events: [Event]
    
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
            
            Map() {
                ForEach(self.events) { event in
                    if let location = event.location {
                        Marker(event.title, coordinate: location.coordinate)
                    }
                }
            }
        }
        .background(Color.backgroundNormalNormal)
    }
}
