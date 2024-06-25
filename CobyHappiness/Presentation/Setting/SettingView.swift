//
//  SettingView.swift
//  CobyHappiness
//
//  Created by Coby on 6/23/24.
//

import SwiftUI

import CobyDS

struct SettingView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(
                leftSide: .left,
                leftAction: {
                    self.dismiss()
                },
                title: "설정"
            )
        }
    }
}

#Preview {
    SettingView()
}
