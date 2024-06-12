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
    
    @Query(sort: \Bunch.date, order: .reverse)
    private var bunches: [Bunch]
    
    @Query(sort: \Memory.date, order: .reverse)
    private var memories: [Memory]
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(
                leftSide: .text,
                leftTitle: "정보",
                rightSide: .icon,
                rightIcon: UIImage.icSetting,
                rightAction: {
                    print("추가")
                }
            )
            
            ScrollView {
                NoteView()
            }
        }
        .background(Color.backgroundNormalNormal)
    }
    
    @ViewBuilder
    private func NoteView() -> some View {
        HStack(spacing: 8) {
            BoxView(
                title: "추억",
                description: "\(self.bunches.count)개"
            )
            
            BoxView(
                title: "뭉치",
                description: "\(self.memories.count)개"
            )
        }
        .padding(.horizontal, BaseSize.horizantalPadding)
        .padding(.top, 8)
    }
    
    @ViewBuilder
    private func BoxView(
        title: String,
        description: String
    ) -> some View {
        VStack(spacing: 0) {
            HStack {
                Text(title)
                    .font(.pretendard(size: 18, weight: .bold))
                    .foregroundStyle(Color.labelNormal)
                
                Spacer()
            }
            
            HStack {
                Text(description)
                    .font(.pretendard(size: 14, weight: .regular))
                    .foregroundStyle(Color.labelNeutral)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
        }
    }
}

#Preview {
    ProfileView()
        .loadCustomFonts()
}
