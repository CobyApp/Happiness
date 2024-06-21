//
//  BunchDetailView.swift
//  CobyHappiness
//
//  Created by Coby on 6/12/24.
//

import SwiftUI
import SwiftData

import CobyDS

struct BunchDetailView: View {
    
    @EnvironmentObject private var appModel: AppViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewModel: BunchDetailViewModel = BunchDetailViewModel()
    @State private var showingSheet = false
    @State private var showingAlert = false
    @State private var isPresented: Bool = false
    
    private var bunch: Bunch
    
    init(
        bunch: Bunch
    ) {
        self.bunch = bunch
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(
                leftSide: .left,
                leftAction: {
                    self.dismiss()
                },
                rightSide: .icon,
                rightIcon: UIImage.icMore,
                rightAction: {
                    self.showingSheet = true
                }
            )
            
            MemoryListView()
        }
        .edgesIgnoringSafeArea(.bottom)
        .actionSheet(isPresented: self.$showingSheet) {
            ActionSheet(
                title: Text("원하는 옵션을 선택해주세요."),
                message: nil,
                buttons: [
                    .default(Text("편집")) {
                        self.isPresented = true
                    },
                    .destructive(Text("삭제")) {
                        self.showingAlert = true
                    },
                    .cancel(Text("취소"))
                ]
            )
        }
        .alert(isPresented: self.$showingAlert) {
            Alert(
                title: Text("추억 뭉치를 삭제하시겠습니까?"),
                message: nil,
                primaryButton: .destructive(
                    Text("삭제"),
                    action: {
                        self.viewModel.removeBunch(bunch: self.bunch)
                        self.dismiss()
                    }
                ),
                secondaryButton: .cancel(Text("취소"))
            )
        }
    }
    
    @ViewBuilder
    private func MemoryListView() -> some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(self.bunch.memories) { memory in
                    MemoryTileView(
                        memory: memory
                    )
                    .onTapGesture {
                        self.appModel.currentActiveItem = memory
                        self.appModel.showDetailView = true
                    }
                }
            }
            .padding(.horizontal, BaseSize.horizantalPadding)
            .padding(.top, 8)
            .padding(.bottom, 20)
        }
    }
}
