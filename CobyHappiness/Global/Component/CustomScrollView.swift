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
    
    @State private var offset: CGFloat = 0.0
    @State private var dragOffset: CGFloat = 0.0
    @State private var contentHeight: CGFloat = 0
    
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
                                }
                        }
                    )
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if offset + value.translation.height > 0 {
                                    let scale = (value.translation.height - 40) / UIScreen.main.bounds.height
                                    
                                    if 1 - scale > 0.7 && 1 - scale <= 1  {
                                        self.scale = 1 - scale
                                        dragOffset = 0
                                    }
                                } else if scale == 1 {
                                    let maxOffset = contentHeight - geometry.size.height < 0 ? 0 : contentHeight - geometry.size.height
                                    
                                    if offset + value.translation.height >= -maxOffset {
                                        dragOffset = value.translation.height
                                    }
                                }
                                
                                if offset + value.translation.height - BaseSize.topAreaPadding - 10 < -BaseSize.fullWidth * 1.2 {
                                    isDown = true
                                } else {
                                    isDown = false
                                }
                            }
                            .onEnded { value in
                                offset += dragOffset
                                
                                if offset > 0 {
                                    offset = 0
                                }
                                
                                dragOffset = 0
                                
                                if scale < 0.8 {
                                    showDetailView = false
                                } else {
                                    scale = 1
                                }
                            }
                    )
            }
        }
    }
}
