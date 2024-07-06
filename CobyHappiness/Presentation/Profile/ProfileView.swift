//
//  ProfileView.swift
//  CobyHappiness
//
//  Created by Coby on 6/9/24.
//

import SwiftUI
import SwiftData

import CobyDS
import ComposableArchitecture

struct ProfileView: View {
   
    @Bindable private var store: StoreOf<ProfileStore>
    
    init(store: StoreOf<ProfileStore>) {
        self.store = store
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(
                leftSide: .title,
                leftTitle: "정보",
                rightSide: .text,
                rightTitle: "설정",
                rightAction: {
                    self.store.send(.navigateToSettingView)
                }
            )
            
            MemoryFilterView()
            
            MemoryListView(memories: self.store.memories.getFilteredMemories(self.store.memoryType))
        }
        .background(Color.backgroundNormalNormal)
        .onAppear {
            self.store.send(.getMemories)
        }
        .navigationDestination(
            item: self.$store.scope(state: \.detailMemory, action: \.detailMemory)
        ) { store in
            DetailMemoryView(store: store).navigationBarHidden(true)
        }
    }
    
    @ViewBuilder
    private func MemoryFilterView() -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                BoxView(
                    isSelected: self.store.memoryType == nil,
                    title: "모두",
                    description: "\(self.store.memories.getFilteredMemories(nil).count)개"
                )
                .onTapGesture {
                    self.store.memoryType = nil
                }
                
                ForEach(MemoryType.allCases, id: \.self) { memoryType in
                    BoxView(
                        isSelected: self.store.memoryType == memoryType,
                        title: memoryType.title,
                        description: "\(self.store.memories.getFilteredMemories(memoryType).count)개"
                    )
                    .onTapGesture {
                        self.store.memoryType = memoryType
                    }
                }
            }
        }
        .contentMargins(.horizontal, BaseSize.horizantalPadding, for: .scrollContent)
        .contentMargins(.vertical, 8, for: .scrollContent)
        .scrollIndicators(.hidden)
    }
    
    @ViewBuilder
    private func BoxView(
        isSelected: Bool,
        title: String,
        description: String
    ) -> some View {
        VStack(spacing: 4) {
            HStack {
                Text(title)
                    .font(.pretendard(size: 16, weight: .regular))
                    .foregroundStyle(Color.labelNormal)
                
                Spacer()
            }
            
            HStack {
                Spacer()
                
                Text(description)
                    .font(.pretendard(size: 14, weight: .regular))
                    .foregroundStyle(Color.labelNeutral)
            }
        }
        .padding(12)
        .background(isSelected ? Color.fillStrong : Color.backgroundNormalNormal)
        .clipShape(.rect(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.lineNormalNeutral, lineWidth: 1)
        )
        .frame(width: 100)
    }
    
    @ViewBuilder
    private func MemoryListView(memories: [MemoryModel]) -> some View {
        if memories.isEmpty {
            EmptyMemoryView(
                showingButton: false
            )
        } else {
            ScrollView {
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
                .padding(.horizontal, BaseSize.horizantalPadding)
                .padding(.top, 8)
                .padding(.bottom, 20)
            }
        }
    }
}
