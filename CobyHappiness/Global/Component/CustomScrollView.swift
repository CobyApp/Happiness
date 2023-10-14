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
    
    @State private var offset: CGFloat = 0.0
    @State private var dragOffset: CGFloat = 0.0
    @State private var contentHeight: CGFloat = 0
    
    let content: Content
    
    init(showDetailView: Binding<Bool>, scale: Binding<CGFloat>, @ViewBuilder content: () -> Content) {
        self._showDetailView = showDetailView
        self._scale = scale
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
                                .preference(
                                    key: HeightPreferenceKey.self,
                                    value: innerGeometry.size.height
                                )
                        }
                    )
                    .onPreferenceChange(HeightPreferenceKey.self) {
                        contentHeight = $0
                    }
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let maxOffset = contentHeight - geometry.size.height < 0 ? 0 : contentHeight - geometry.size.height
                                print("contentHeight: \(contentHeight)")
                                print("geometry.size.height: \(geometry.size.height)")
                                print("maxOffset: \(maxOffset)")
                                print("getOffset: \(offset + value.translation.height)")
                                
                                if offset + value.translation.height >= 0 {
                                    let scale = value.translation.height / UIScreen.main.bounds.height
                                    
                                    if 1 - scale > 0.8 && 1 - scale <= 1  {
                                        self.scale = 1 - scale
                                        dragOffset = 0
                                    }
                                } else if scale == 1 {
//                                    if offset + value.translation.height > maxOffset {}
                                    dragOffset = value.translation.height
                                }
                            }
                            .onEnded { value in
                                offset += value.translation.height
                                
                                if offset > 0 {
                                    offset = 0
                                }
                                
                                dragOffset = 0
                                
                                if scale < 0.9 {
                                    showDetailView = false
                                }
                                scale = 1
                            }
                    )
            }
        }
    }
}

struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
