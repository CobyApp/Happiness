//
//  SettingView.swift
//  CobyHappiness
//
//  Created by Coby on 6/23/24.
//

import SwiftUI

import CobyDS
import ComposableArchitecture

struct SettingView: View {
   
    @Bindable private var store: StoreOf<SettingStore>
    
    init(store: StoreOf<SettingStore>) {
        self.store = store
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(
                leftSide: .left,
                leftAction: {
                    self.store.send(.dismiss)
                },
                title: "설정"
            )
            
            Spacer()
        }
    }
}
