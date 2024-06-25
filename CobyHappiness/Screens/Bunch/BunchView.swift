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

    @State private var viewModel: BunchViewModel = BunchViewModel()
    @State private var isPresented: Bool = false
    
    private let columns: [GridItem] = Array(
        repeating: GridItem(.flexible(), spacing: 8),
        count: 2
    )
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(
                leftSide: .title,
                leftTitle: "뭉치",
                rightSide: .text,
                rightTitle: "뭉치 추가",
                rightAction: {
                    self.isPresented = true
                }
            )
            
            BunchGridView()
        }
        .background(Color.backgroundNormalNormal)
        .navigationDestination(for: Bunch.self) { bunch in
            BunchDetailView(bunch: bunch).navigationBarHidden(true)
        }
        .fullScreenCover(
            isPresented: self.$isPresented,
            onDismiss: {
                self.viewModel.fetchBunches()
            }
        ) {
            EditBunchPageView()
        }
    }
    
    @ViewBuilder
    private func BunchGridView() -> some View {
        if self.viewModel.bunches.isEmpty {
            EmptyBunchView {
                self.isPresented = true
            }
        } else {
            ScrollView {
                LazyVGrid(columns: self.columns, spacing: 20) {
                    ForEach(self.viewModel.bunches, id: \.self) { bunch in
                        NavigationLink(value: bunch) {
                            ThumbnailTitleView(
                                image: bunch.image,
                                title: bunch.title,
                                description: bunch.term
                            )
                            .frame(width: BaseSize.cellWidth)
                        }
                    }
                }
                .padding(.horizontal, BaseSize.horizantalPadding)
                .padding(.top, 8)
                .padding(.bottom, 20)
            }
        }
    }
}
