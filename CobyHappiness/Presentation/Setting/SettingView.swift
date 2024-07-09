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
                }
            )
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    TitleView(title: "설정")
                    
                    SettingListView()
                }
            }
        }
        .background(Color.backgroundNormalNormal)
        .navigationDestination(
            item: self.$store.scope(state: \.theme, action: \.theme)
        ) { store in
            ThemeView(store: store).navigationBarHidden(true)
        }
        .alert(
            self.$store.scope(state: \.deleteAlert, action: \.deleteAlert)
        )
    }
    
    @ViewBuilder
    private func SettingListView() -> some View {
        VStack(spacing: 0) {            
            SettingButton(title: "테마") {
                self.store.send(.showThemeView)
            }
            
            SettingButton(title: "데이터 초기화") {
                self.store.send(.showDeleteAlert)
            }
        }
        .padding(.horizontal, BaseSize.horizantalPadding)
    }
}
