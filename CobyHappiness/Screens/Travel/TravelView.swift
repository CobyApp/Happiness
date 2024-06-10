//
//  TravelView.swift
//  CobyHappiness
//
//  Created by Coby on 6/9/24.
//

import SwiftUI
import SwiftData

import CobyDS

struct TravelView: View {
    
    @Query
    private var events: [Event]
    
    private let columns: [GridItem] = Array(
        repeating: GridItem(.flexible(), spacing: 20),
        count: 2
    )
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(
                leftSide: .text,
                leftTitle: "여행",
                rightSide: .icon,
                rightIcon: Image("plus"),
                rightAction: {
                    print("추가")
                }
            )
            
            LazyVGrid(columns: self.columns, spacing: 20) {
                ForEach(self.events, id: \.self) { event in
                    ThumbnailTitleView(
                        image: event.photos.first?.image,
                        title: event.title,
                        description: event.note
                    )
                    .frame(width: BaseSize.cellWidth)
                }
            }
            .padding(.horizontal, BaseSize.horizantalPadding)
            .padding(.top, 8)
            .padding(.bottom, 20)
            
            Spacer()
        }
        .background(Color.backgroundNormalNormal)
    }
}
