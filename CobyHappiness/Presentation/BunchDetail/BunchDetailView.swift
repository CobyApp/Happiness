//
//  BunchDetailView.swift
//  CobyHappiness
//
//  Created by Coby on 6/12/24.
//

import SwiftUI

import CobyDS
import ComposableArchitecture

struct BunchDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Bindable private var store: StoreOf<BunchDetailStore>
    
    init(store: StoreOf<BunchDetailStore>) {
        self.store = store
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(
                leftSide: .left,
                leftAction: {
                    self.store.send(.dismiss)
                },
                rightSide: .icon,
                rightIcon: UIImage.icMore,
                rightAction: {
                    self.store.send(.showOptionSheet)
                }
            )
            
            MemoryListView(memories: self.store.bunch.memories)
        }
        .edgesIgnoringSafeArea(.bottom)
        .actionSheet(isPresented: self.$store.showingSheet) {
            ActionSheet(
                title: Text("원하는 옵션을 선택해주세요."),
                message: nil,
                buttons: [
                    .default(Text("편집")) {
                        self.store.send(.showEditBunch)
                    },
                    .destructive(Text("삭제")) {
                        self.store.send(.showDeleteAlert)
                    },
                    .cancel(Text("취소"))
                ]
            )
        }
        .alert(isPresented: self.$store.showingAlert) {
            Alert(
                title: Text("추억 뭉치를 삭제하시겠습니까?"),
                message: nil,
                primaryButton: .destructive(
                    Text("삭제"),
                    action: {
                        self.store.send(.deleteBunch(self.store.bunch.id))
                    }
                ),
                secondaryButton: .cancel(Text("취소"))
            )
        }
        .fullScreenCover(
            isPresented: self.$store.showingEditBunchView
        ) {
            EditBunchView(store: Store(initialState: EditBunchStore.State(
                bunch: self.store.bunch
            )) {
                EditBunchStore()
            })
        }
        .onChange(of: self.store.isPresented) {
            self.dismiss()
        }
    }
    
    @ViewBuilder
    private func MemoryListView(memories: [MemoryModel]) -> some View {
        if memories.isEmpty {
            EmptyMemoryView(
                showingButton: false
            )
            .padding(.top, -100)
        } else {
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(memories) { memory in
                        MemoryTileView(
                            memory: memory
                        )
                        .onTapGesture {
                            self.store.send(.showMemoryDetail(memory))
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
