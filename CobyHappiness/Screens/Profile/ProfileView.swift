//
//  ProfileView.swift
//  CobyHappiness
//
//  Created by Coby on 6/9/24.
//

import SwiftUI
import SwiftData

import CobyDS

struct ProfileView: View {
   
    @EnvironmentObject private var appModel: AppViewModel
    
    @State private var viewModel: ProfileViewModel = ProfileViewModel()
    @State private var selection: String? = nil
    @State private var selectedMemoryType: MemoryType? = nil

    var body: some View {
        VStack(spacing: 0) {
            TopBarView(
                leftSide: .title,
                leftTitle: "정보",
                rightSide: .icon,
                rightIcon: UIImage.icSetting,
                rightAction: {
                    print("설정")
                }
            )
            
            NoteView()
            
            MemoryListView()
        }
        .background(Color.backgroundNormalNormal)
    }
    
    @ViewBuilder
    private func NoteView() -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                BoxView(
                    isSelected: self.selectedMemoryType == nil,
                    title: "모두",
                    description: "\(self.viewModel.getMemoryCount(nil))개"
                )
                .onTapGesture {
                    self.selectedMemoryType = nil
                }
                
                ForEach(MemoryType.allCases, id: \.self) { memoryType in
                    BoxView(
                        isSelected: self.selectedMemoryType == memoryType,
                        title: memoryType.title,
                        description: "\(self.viewModel.getMemoryCount(memoryType))개"
                    )
                    .onTapGesture {
                        self.selectedMemoryType = memoryType
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
                    .font(.pretendard(size: 16, weight: .medium))
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
    private func MemoryListView() -> some View {
        if self.viewModel.getFilteredMemory(self.selectedMemoryType).isEmpty {
            EmptyMemoryView(
                showingButton: false
            )
        } else {
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(self.viewModel.getFilteredMemory(self.selectedMemoryType)) { memory in
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
}
