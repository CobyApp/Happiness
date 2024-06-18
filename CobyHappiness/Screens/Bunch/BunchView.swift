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
    @State private var selection: String? = nil
    
    private let columns: [GridItem] = Array(
        repeating: GridItem(.flexible(), spacing: 8),
        count: 2
    )
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(
                leftSide: .text,
                leftTitle: "뭉치",
                rightSide: .icon,
                rightIcon: UIImage.icPlus,
                rightAction: {
                    self.isPresented = true
                }
            )
            
            ScrollView {
                LazyVGrid(columns: self.columns, spacing: 20) {
                    ForEach(self.viewModel.bunches, id: \.self) { bunch in
                        NavigationLink(value: bunch) {
                            ThumbnailTitleView(
                                image: bunch.image,
                                title: bunch.title,
                                description: bunch.note
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
}
