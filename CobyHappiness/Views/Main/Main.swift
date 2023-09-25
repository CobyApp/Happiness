//
//  Main.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 2023/09/21.
//

import SwiftUI
import SwiftData

struct Main: View {
    @Environment(\.modelContext) private var context
    
    @Query(sort: \Paper.date, order: .reverse)
    private var papers: [Paper]
    
    @State private var currentIndex: Int = 0
    @GestureState private var dragOffset: CGFloat = 0
    
    @State private var isPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    ForEach(0..<papers.count, id: \.self) { index in
                        PaperView(paper: papers[index])
                            .frame(width: BaseSize.fullWidth, height: BaseSize.fullHeight)
                            .cornerRadius(25)
                            .opacity(currentIndex == index ? 1.0 : 0.5)
                            .scaleEffect(currentIndex == index ? 1.0 : 0.8)
                            .offset(x: CGFloat(index - currentIndex) * BaseSize.fullWidth + dragOffset, y: 0)
                    }
                }
                .gesture(
                    DragGesture()
                        .onEnded({ value in
                            let threshold: CGFloat = 50
                            if value.translation.width > threshold {
                                withAnimation {
                                    currentIndex = max(0, currentIndex - 1)
                                }
                            } else if value.translation.width < -threshold {
                                withAnimation {
                                    currentIndex = min(papers.count - 1, currentIndex + 1)
                                }
                            }
                        })
                )
            }
            .navigationBarHidden(true)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button {
                            withAnimation {
                                currentIndex = max(0, currentIndex - 1)
                            }
                        } label: {
                            Image(systemName: "arrow.left")
                                .font(.title)
                        }

                        Spacer()
                        
                        Button {
                            withAnimation {
                                currentIndex = min(papers.count - 1, currentIndex + 1)
                            }
                        } label: {
                            Image(systemName: "arrow.right")
                                .font(.title)
                        }
                    }
                }
            }
            .onAppear {
                guard let paper = papers.first else {
                    createPages()
                    return
                }
                
                if paper.date.format("yyyy-mm-dd") != Date().format("yyyy-mm-dd") {
                    createPages()
                }
            }
        }
    }
    
    private func createPages() {
        let paper = Paper()
        context.insert(paper)
        
        withAnimation {
            currentIndex = 0
        }
    }
}
