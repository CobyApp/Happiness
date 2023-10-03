//
//  CardView.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 10/3/23.
//

import SwiftUI

struct CardView: View {
    var event: Event
    
    var body: some View {
        if let uiImage = UIImage(data: event.photo) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: BaseSize.fullWidth, height: BaseSize.fullHeight)
                .clipShape(.rect(cornerRadius: 15))
                .overlay {
                    OverlayView(event)
                }
                .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y: 10)
                .padding(.bottom, BaseSize.verticalPadding)
        }
    }
    
    @ViewBuilder
    func OverlayView(_ event: Event) -> some View {
        ZStack(alignment: .bottomLeading, content: {
            LinearGradient(colors: [
                .clear,
                .clear,
                .clear,
                .clear,
                .clear,
                .black.opacity(0.1),
                .black.opacity(0.5),
                .black
            ], startPoint: .top, endPoint: .bottom)
            
            VStack(alignment: .leading, spacing: 4, content: {
                Text(event.title)
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundStyle(.white)
                
                Text(event.date.format("MMM d, yyyy"))
                    .font(.callout)
                    .foregroundStyle(.white.opacity(0.8))
            })
            .padding(20)
        })
    }
}
