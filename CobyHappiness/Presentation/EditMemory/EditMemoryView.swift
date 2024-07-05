//
//  EditMemoryView.swift
//  CobyHappiness
//
//  Created by Coby on 6/11/24.
//

import SwiftUI

import CobyDS
import ComposableArchitecture

struct EditMemoryView: View {
    
    @Bindable private var store: StoreOf<EditMemoryStore>
    
    init(store: StoreOf<EditMemoryStore>) {
        self.store = store
    }
    
    var isPageDisabled: Bool {
        switch self.store.selection {
        case .first:
            return self.store.memory.isFirstPageDisabled
        case .second:
            return self.store.memory.isSecondPageDisabled
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(
                leftSide: .left,
                leftAction: {
                    self.store.send(.dismiss)
                }
            )
            
            TabView(selection: self.$store.selection) {
                EditMemoryFirstPageView(
                    memory: self.$store.memory
                )
                .tag(PageType.first)
                .simultaneousGesture(DragGesture())
                
                EditMemorySecondPageView(
                    memory: self.$store.memory
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
        .onTapGesture {
            self.closeKeyboard()
        }
    }
}
