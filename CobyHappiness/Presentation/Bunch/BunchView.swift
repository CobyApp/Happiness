//
//  BunchView.swift
//  CobyHappiness
//
//  Created by Coby on 6/9/24.
//

import SwiftUI

import CobyDS
import ComposableArchitecture

struct BunchView: View {

    @Bindable private var store: StoreOf<BunchStore>
    
    private let columns: [GridItem] = Array(
        repeating: GridItem(.flexible(), spacing: 8),
        count: 2
    )
    
    init(store: StoreOf<BunchStore>) {
        self.store = store
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(
                leftSide: .title,
                leftTitle: "뭉치",
                rightSide: .text,
                rightTitle: "뭉치 추가",
                rightAction: {
                    self.store.send(.showAddBunch)
                }
            )
            
            BunchGridView()
        }
        .background(Color.backgroundNormalNormal)
        .onAppear {
            self.store.send(.getBunches)
        }
        .navigationDestination(
            item: self.$store.scope(state: \.addBunch, action: \.addBunch)
        ) { store in
            EditBunchView(store: store).navigationBarHidden(true)
        }
        .navigationDestination(
            item: self.$store.scope(state: \.detailBunch, action: \.detailBunch)
        ) { store in
            DetailBunchView(store: store).navigationBarHidden(true)
        }
    }
    
    @ViewBuilder
    private func BunchGridView() -> some View {
        if self.store.bunches.isEmpty {
            EmptyBunchView {
                self.store.send(.showAddBunch)
            }
        } else {
            ScrollView {
                LazyVGrid(columns: self.columns, spacing: 20) {
                    ForEach(self.store.bunches, id: \.self) { bunch in
                        ThumbnailTitleView(
                            image: bunch.image,
                            title: bunch.title,
                            description: bunch.term
                        )
                        .frame(width: BaseSize.cellWidth)
                        .onTapGesture {
                            self.store.send(.showDetailBunch(bunch))
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
