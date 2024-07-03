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
        NavigationStack(
            path: self.$store.scope(state: \.path, action: \.path)
        ) {
            BunchRootView()
        } destination: { store in
            switch store.case {
            case .detailBunch(let store):
                BunchDetailView(store: store)
                    .navigationBarHidden(true)
            case .editBunch(let store):
                EditBunchView(store: store)
                    .navigationBarHidden(true)
            }
        }
    }
    
    @ViewBuilder
    private func BunchRootView() -> some View {
        VStack(spacing: 0) {
            TopBarView(
                leftSide: .title,
                leftTitle: "뭉치",
                rightSide: .text,
                rightTitle: "뭉치 추가",
                rightAction: {
                    self.store.send(.showEditBunch)
                }
            )
            
            BunchGridView()
        }
        .background(Color.backgroundNormalNormal)
        .fullScreenCover(
            isPresented: self.$store.showingEditBunchView,
            onDismiss: {
                self.store.send(.getBunches)
            }
        ) {
            EditBunchView(store: Store(initialState: EditBunchStore.State()) {
                EditBunchStore()
            })
        }
        .onAppear {
            self.store.send(.getBunches)
        }
    }
    
    @ViewBuilder
    private func BunchGridView() -> some View {
        if self.store.bunches.isEmpty {
            EmptyBunchView {
                self.store.send(.showEditBunch)
            }
        } else {
            ScrollView {
                LazyVGrid(columns: self.columns, spacing: 20) {
                    ForEach(self.store.bunches, id: \.self) { bunch in
                        NavigationLink(
                            state: BunchStore.Path.State.detailBunch(BunchDetailStore.State(bunch: bunch))
                        ) {
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
