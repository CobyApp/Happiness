//
//  CardView.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 10/3/23.
//

import SwiftUI

struct CardView: View {
    var event: Event
    var animation: Namespace.ID
    
    var body: some View {
        if let photo = event.photos.first {
            if let uiImage = UIImage(data: photo.image) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: BaseSize.cardWidth, height: BaseSize.cardWidth * 1.2)
                    .matchedGeometryEffect(id: "image" + event.id.uuidString, in: animation)
                    .overlay {
                        OverlayView()
                    }
                    .clipShape(.rect(cornerRadius: 15))
                    .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 5)
            }
        }
    }
    
    @ViewBuilder
    func OverlayView() -> some View {
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
            
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.title.bold())
                    .foregroundStyle(.white)
                
                Text(event.date.format("MMM d, yyyy"))
                    .font(.callout.bold())
                    .foregroundStyle(.white.opacity(0.8))
            }
            .padding(20)
        })
    }
}
