//
//  CardView.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 10/3/23.
//

import SwiftUI

struct CardView: View {
    @EnvironmentObject private var appModel: AppViewModel
    
    var event: Event
    var animation: Namespace.ID
    
    var body: some View {
        if let uiImage = UIImage(data: event.photo) {
            Group {
                if appModel.currentActiveItem?.id == event.id && appModel.showDetailView {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: BaseSize.cardWidth)
                        .opacity(0)
                } else {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: BaseSize.cardWidth)
                        .overlay {
                            OverlayView(event)
                        }
                        .clipShape(.rect(cornerRadius: 15))
                        .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 5)
                        .matchedGeometryEffect(id: event.id.uuidString, in: animation)
                }
            }
            .padding(.vertical, 20)
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
