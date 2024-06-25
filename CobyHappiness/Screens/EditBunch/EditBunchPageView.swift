//
//  EditBunchPageView.swift
//  CobyHappiness
//
//  Created by Coby on 6/16/24.
//

import SwiftUI
import SwiftData

import CobyDS

struct EditBunchPageView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var selection = 0
    @State private var bunch: Bunch
    
    @State private var viewModel: EditBunchViewModel = EditBunchViewModel()
    
    init(
        bunch: Bunch = Bunch()
    ) {
        self._bunch = State(wrappedValue: bunch)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(
                leftSide: .left,
                leftAction: {
                    self.dismiss()
                },
                title: self.selection == 0 ? "추억 선택" : "뭉치 기록"
            )
            
            TabView(selection: self.$selection) {
                SelectMemoriesView(
                    selection: self.$selection,
                    bunch: self.$bunch,
                    memories: self.viewModel.memories
                )
                .tag(0)
                
                EditBunchContentView(
                    selection: self.$selection,
                    bunch: self.$bunch
                )
                .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .background(Color.backgroundNormalNormal)
            
            
            let isDisabled = (self.selection == 0 && self.bunch.memories.isEmpty) || (self.selection == 1 && self.bunch.title.count == 0)
            
            Button {
                if !isDisabled {
                    if self.selection == 0 {
                        self.bunch.startDate = self.bunch.memories.map { $0.date }.min() ?? .now
                        self.bunch.endDate = self.bunch.memories.map { $0.date }.max() ?? .now
                        self.selection = 1
                    } else {
                        self.viewModel.appendBunch(bunch: self.bunch)
                        self.dismiss()
                    }
                }
            } label: {
                Text(self.selection == 0 ? "선택" : "저장")
            }
            .buttonStyle(
                CBButtonStyle(
                    buttonColor: Color.redNormal,
                    disable: isDisabled
                )
            )
            .padding(.horizontal, BaseSize.horizantalPadding)
            .padding(.bottom, 20)
        }
    }
}
