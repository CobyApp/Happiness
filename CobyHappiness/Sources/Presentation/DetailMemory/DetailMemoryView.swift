//
//  DetailMemoryView.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 10/4/23.
//

import SwiftUI

import CobyDS
import ComposableArchitecture

struct DetailMemoryView: View {
    
    @Bindable private var store: StoreOf<DetailMemoryStore>
    
    init(store: StoreOf<DetailMemoryStore>) {
        self.store = store
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    PhotosView(photos: self.store.memory.photos)
                    
                    ContentView(memory: self.store.memory)
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
            self.store.send(.getMemory)
        }
        .navigationDestination(
            item: self.$store.scope(state: \.editMemory, action: \.editMemory)
        ) { store in
            EditMemoryView(store: store).navigationBarHidden(true)
        }
        .confirmationDialog(
            self.$store.scope(state: \.optionSheet, action: \.optionSheet)
        )
        .alert(
            self.$store.scope(state: \.deleteAlert, action: \.deleteAlert)
        )
        .alert(
            self.$store.scope(state: \.confirmAlert, action: \.confirmAlert)
        )
    }
    
    @ViewBuilder
    private func ContentView(memory: MemoryModel) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(memory.title)
                    .font(.pretendard(size: 20, weight: .semibold))
                    .foregroundStyle(Color.labelNormal)
                
                Text(memory.date.formatLong)
                    .font(.pretendard(size: 14, weight: .regular))
                    .foregroundStyle(Color.labelAlternative)
            }
            
            CBDivider()
            
            Text(memory.note)
                .font(.pretendard(size: 16, weight: .regular))
                .foregroundColor(Color.labelNormal)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, BaseSize.horizantalPadding)
        .frame(maxWidth: .infinity)
    }
}
