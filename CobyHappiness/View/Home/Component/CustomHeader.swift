//
//  CustomHeader.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 10/4/23.
//

import SwiftUI

struct CustomHeader: View {
    @Binding var isPresented: Bool
    @Binding var searchText: String
    
    var body: some View {
        HStack(spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .foregroundColor(.grayscale100)
                
                TextField("Search", text: .constant(""))
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background{
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.white)
            }
            
            Button {
                isPresented = true
            } label: {
                Image(systemName: "plus")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.grayscale100)
                    .frame(width: 25, height: 25)
                    .padding(12)
                    .background{
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.white)
                    }
            }
        }
        .padding(.horizontal, BaseSize.horizantalPadding)
    }
}
