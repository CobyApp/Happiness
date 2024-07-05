//
//  DetailPhotosView.swift
//  CobyHappiness
//
//  Created by Coby on 7/5/24.
//

import SwiftUI

import CobyDS

struct DetailPhotosView: View {
    
    private let photos: [UIImage]
    
    init(photos: [UIImage]) {
        self.photos = photos
    }
    
    var body: some View {
        TabView {
            ForEach(self.photos, id: \.self) { photo in
                Image(uiImage: photo)
                    .resizable()
                    .scaledToFill()
                    .frame(width: BaseSize.screenWidth, height: BaseSize.screenWidth)
                    .clipped()
                    .contentShape(Rectangle())
                    .ignoresSafeArea()
            }
        }
        .background(Color.backgroundNormalAlternative)
        .frame(width: BaseSize.screenWidth, height: BaseSize.screenWidth)
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
    }
}
