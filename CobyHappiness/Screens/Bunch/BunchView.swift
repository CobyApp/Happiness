//
//  BunchView.swift
//  CobyHappiness
//
//  Created by Coby on 6/9/24.
//

import SwiftUI
import SwiftData

import CobyDS

struct BunchView: View {
    
    @Query(sort: \Bunch.date, order: .reverse)
    private var bunchs: [Bunch]
    
    @State private var isPresented: Bool = false
    @State private var bunch: Bunch? = nil
    
    private let columns: [GridItem] = Array(
        repeating: GridItem(.flexible(), spacing: 20),
        count: 2
    )
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(
                leftSide: .text,
                leftTitle: "뭉치",
                rightSide: .icon,
                rightIcon: Image("plus"),
                rightAction: {
                    self.isPresented = true
                }
            )
            
            ScrollView {
                LazyVGrid(columns: self.columns, spacing: 20) {
                    ForEach(self.bunchs, id: \.self) { bunch in
                        ThumbnailTitleView(
                            image: bunch.image,
                            title: bunch.title,
                            description: bunch.note
                        )
                        .frame(width: BaseSize.cellWidth)
                        .onTapGesture {
                            self.bunch = bunch
                        }
                    }
                }
                .padding(.horizontal, BaseSize.horizantalPadding)
                .padding(.top, 8)
                .padding(.bottom, 20)
            }
        }
        .background(Color.backgroundNormalNormal)
        .fullScreenCover(isPresented: self.$isPresented) {
            SelectMemoriesView()
        }
        .fullScreenCover(item: self.$bunch, onDismiss: { self.bunch = nil }) { item in
            BunchDetailView(bunch: item)
        }
    }
}
