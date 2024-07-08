//
//  ThemeView.swift
//  CobyHappiness
//
//  Created by Coby Kim on 7/8/24.
//

import SwiftUI

import CobyDS
import ComposableArchitecture

struct ThemeView: View {
   
    @Bindable private var store: StoreOf<ThemeStore>
    
    init(store: StoreOf<ThemeStore>) {
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
                    TitleView(title: "테마")
                    
                    ThemeListView()
                }
            }
            
            Button {
                self.store.send(.saveColor(self.store.selectedColorType))
            } label: {
                Text("완료")
            }
            .buttonStyle(
                CBButtonStyle(
                    buttonColor: self.store.selectedColorType.color
                )
            )
            .padding(.horizontal, BaseSize.horizantalPadding)
            .padding(.bottom, 20)
        }
    }
    
    @ViewBuilder
    private func ThemeListView() -> some View {
        VStack(spacing: 0) {
            ForEach(ColorType.allCases, id: \.self) { colorType in
                RadioListItemWithColorView(
                    isChecked: self.store.selectedColorType == colorType,
                    color: colorType.color,
                    title: colorType.rawValue
                )
            }
        }
    }
}
