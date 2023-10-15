//
//  CustomScrollView.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 10/14/23.
//

import SwiftUI

struct CustomScrollView<Content: View>: View {
    @Binding var showDetailView: Bool
    @Binding var scale: CGFloat
    @Binding var isDown: Bool
    
    @State private var contentHeight: CGFloat = 0
    @State private var maxOffset: CGFloat = 0.0
    @State private var offset: CGFloat = 0.0
    @State private var dragOffset: CGFloat = 0.0
    @State private var deceleration: Double = 0.0
    
    let content: Content
    
    init(
        showDetailView: Binding<Bool>,
        scale: Binding<CGFloat>,
        isDown: Binding<Bool>,
        @ViewBuilder content: () -> Content
    ) {
        self._showDetailView = showDetailView
        self._scale = scale
        self._isDown = isDown
        self.content = content()
    }
    
    var body: some View {
        // GeometryReader를 사용하여 뷰의 크기 및 위치 정보를 가져옴
        GeometryReader { geometry in
            // ZStack을 사용하여 여러 뷰를 겹치게 함
            ZStack {
                // 내용을 표시하는 부분
                content
                    .offset(y: offset + dragOffset)
                    .background(
                        GeometryReader { innerGeometry in
                            Color.clear
                                .onAppear {
                                    contentHeight = innerGeometry.size.height
                                    maxOffset = geometry.size.height - contentHeight < 0 ? geometry.size.height - contentHeight : 0
                                }
                        }
                    )
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                withAnimation {
                                    let nextOffset = offset + value.translation.height
                                    
                                    if nextOffset >= 0 {
                                        let scale = (value.translation.height - 100) / UIScreen.main.bounds.height
                                        
                                        if 1 - scale > 0.7 && scale > 0 {
                                            self.scale = 1 - scale
                                            dragOffset = 0
                                        }
                                    } else if scale == 1 {
                                        if nextOffset > maxOffset {
                                            dragOffset = value.translation.height
                                        }
                                    }
                                    
                                    if nextOffset - BaseSize.topAreaPadding - 10 < -BaseSize.fullWidth * 1.2 {
                                        isDown = true
                                    } else {
                                        isDown = false
                                    }
                                }
                            }
                            .onEnded { value in
                                withAnimation(.spring()) {
                                    let gestureVelocity = value.predictedEndLocation.y - value.location.y
                                    deceleration = Double(gestureVelocity)
                                    continueAnimation()
                                    
                                    if scale < 0.8 {
                                        showDetailView = false
                                    }
                                    
                                    scale = 1
                                }
                            }
                    )
            }
        }
    }
    
    private func continueAnimation() {
        if scale == 1 {
            offset += dragOffset + CGFloat(deceleration * 2)
        }
        
        dragOffset = 0.0
        deceleration = 0.0
        
        if offset >= 0 {
            offset = 0
        } else if offset < maxOffset {
            offset = maxOffset
        }
        
        if offset - BaseSize.topAreaPadding - 10 < -BaseSize.fullWidth * 1.2 {
            isDown = true
        } else {
            isDown = false
        }
    }
}
