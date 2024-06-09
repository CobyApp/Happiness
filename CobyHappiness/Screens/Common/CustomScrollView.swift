//
//  CustomScrollView.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 10/14/23.
//

import SwiftUI

import CobyDS

struct CustomScrollView<Content: View>: View {
    
    @Binding var showDetailView: Bool
    @Binding var scale: CGFloat
    @Binding var isDown: Bool
    
    @State private var contentHeight: CGFloat = 0
    @State private var maxOffset: CGFloat = 0.0
    @State private var offset: CGFloat = 0.0
    @State private var dragOffset: CGFloat = 0.0
    @State private var deceleration: Double = 0.0
    
    private let content: Content
    
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
        GeometryReader { geometry in
            ZStack {
                self.content
                    .offset(y: self.offset + self.dragOffset)
                    .background(
                        GeometryReader { innerGeometry in
                            Color.clear
                                .onAppear {
                                    self.contentHeight = innerGeometry.size.height
                                    self.maxOffset = min(geometry.size.height - self.contentHeight, 0)
                                }
                        }
                    )
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                self.handleDragChanged(value, geometry: geometry)
                            }
                            .onEnded { value in
                                self.handleDragEnded(value)
                            }
                    )
            }
        }
    }
    
    private func handleDragChanged(_ value: DragGesture.Value, geometry: GeometryProxy) {
        withAnimation {
            let nextOffset = self.offset + value.translation.height
            
            if nextOffset >= 0 {
                let scaleValue = (value.translation.height - 100) / UIScreen.main.bounds.height
                if 1 - scaleValue > 0.75 && scaleValue > 0 {
                    self.scale = 1 - scaleValue
                    self.dragOffset = 0
                }
            } else if self.scale == 1 {
                if nextOffset > self.maxOffset {
                    self.dragOffset = value.translation.height
                }
            }
            
            self.isDown = nextOffset - BaseSize.topAreaPadding - 10 < -BaseSize.screenWidth * 1.2
        }
    }
    
    private func handleDragEnded(_ value: DragGesture.Value) {
        withAnimation(.spring()) {
            let gestureVelocity = value.predictedEndLocation.y - value.location.y
            self.deceleration = Double(gestureVelocity)
            self.continueAnimation()
            
            if self.scale < 0.9 {
                self.showDetailView = false
            }
            
            self.scale = 1
        }
    }
    
    private func continueAnimation() {
        if self.scale == 1 {
            self.offset += self.dragOffset + CGFloat(self.deceleration * 0.5)
        }
        
        self.dragOffset = 0.0
        self.deceleration = 0.0
        
        if self.offset >= 0 {
            self.offset = 0
        } else if self.offset < self.maxOffset {
            self.offset = self.maxOffset
        }
        
        self.isDown = self.offset - BaseSize.topAreaPadding - 10 < -BaseSize.screenWidth * 1.2
    }
}
