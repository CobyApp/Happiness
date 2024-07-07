//
//  DetailBunchView.swift
//  CobyHappiness
//
//  Created by Coby on 6/12/24.
//

import SwiftUI

import CobyDS
import ComposableArchitecture

struct DetailBunchView: View {
    
    @Bindable private var store: StoreOf<DetailBunchStore>
    
    init(store: StoreOf<DetailBunchStore>) {
        self.store = store
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    PhotosView(photos: self.store.bunch.photos)
                    
                    ContentView(bunch: self.store.bunch)
                }
                .padding(.bottom, BaseSize.verticalPadding)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .background(Color.backgroundNormalNormal)
        .overlay(alignment: .top) {
            TopBarView(
                barType: .transParents,
                leftSide: .iconInverse,
                leftIcon: UIImage.icClose,
                leftAction: {
                    self.store.send(.dismiss)
                },
                rightSide: .iconInverse,
                rightIcon: UIImage.icMore,
                rightAction: {
                    self.store.send(.showOptionSheet)
                }
            )
        }
        .onAppear {
            self.store.send(.getBunch)
        }
        .navigationDestination(
            item: self.$store.scope(state: \.detailMemory, action: \.detailMemory)
        ) { store in
            DetailMemoryView(store: store).navigationBarHidden(true)
        }
        .navigationDestination(
            item: self.$store.scope(state: \.editBunch, action: \.editBunch)
        ) { store in
            EditBunchView(store: store).navigationBarHidden(true)
        }
        .confirmationDialog(
            self.$store.scope(state: \.optionSheet, action: \.optionSheet)
        )
        .alert(
            self.$store.scope(state: \.deleteAlert, action: \.deleteAlert)
        )
    }
    
    @ViewBuilder
    private func ContentView(bunch: BunchModel) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(bunch.title)
                    .font(.pretendard(size: 20, weight: .semibold))
                    .foregroundStyle(Color.labelNormal)
                
                Text(bunch.termLong)
                    .font(.pretendard(size: 14, weight: .regular))
                    .foregroundStyle(Color.labelAlternative)
            }
            
            CBDivider()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("목록")
                    .font(.pretendard(size: 17, weight: .semibold))
                    .foregroundColor(Color.labelNormal)
                
                MemoryListView(memories: bunch.memories)
            }
        }
        .padding(.horizontal, BaseSize.horizantalPadding)
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private func MemoryListView(memories: [MemoryModel]) -> some View {
        if memories.isEmpty {
            EmptyMemoryView(
                showingButton: false
            )
        } else {
            LazyVStack(spacing: 8) {
                ForEach(memories) { memory in
                    ThumbnailTileView(
                        image: memory.photos.first,
                        title: memory.title,
                        subTitle: memory.date.formatShort,
                        description: memory.note
                    )
                    .frame(width: BaseSize.fullWidth, height: 120)
                    .onTapGesture {
                        self.store.send(.showDetailMemory(memory))
                    }
                }
            }
        }
    }
}
