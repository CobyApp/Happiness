//
//  EditBunchView.swift
//  CobyHappiness
//
//  Created by Coby on 6/16/24.
//

import SwiftUI

import CobyDS
import ComposableArchitecture

struct EditBunchView: View {
    
    @Bindable private var store: StoreOf<EditBunchStore>
    
    init(store: StoreOf<EditBunchStore>) {
        self.store = store
    }
    
    var isPageDisabled: Bool {
        switch self.store.selection {
        case .first:
            return self.store.bunch.isFirstPageDisabled
        case .second:
            return self.store.bunch.isSecondPageDisabled
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(
                leftSide: .left,
                leftAction: {
                    self.store.send(.showCloseAlert)
                }
            )
            
            TabView(selection: self.$store.selection) {
                EditBunchFirstPageView(
                    bunch: self.$store.bunch,
                    memories: self.store.memories
                )
                .tag(PageType.first)
                .simultaneousGesture(DragGesture())
                
                EditBunchSecondPageView(
                    bunch: self.$store.bunch
                )
                .tag(PageType.second)
                .simultaneousGesture(DragGesture())
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeOut(duration: 0.2), value: self.store.selection)
            
            PageBottomButtonView(
                selection: self.$store.selection,
                isDisabled: self.isPageDisabled,
                buttonAction: {
                    self.closeKeyboard()
                    self.store.send(.completeButtonTapped)
                }
            )
        }
        .background(Color.backgroundNormalNormal)
        .onAppear {
            self.store.send(.getMemories)
        }
        .alert(
            self.$store.scope(state: \.closeAlert, action: \.closeAlert)
        )
    }
}
