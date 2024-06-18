//
//  MemoryDetailView.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 10/4/23.
//

import SwiftUI
import SwiftData

import CobyDS

struct MemoryDetailView: View {
    
    @EnvironmentObject private var appModel: AppViewModel
    
    @State private var viewModel: MemoryDetailViewModel = MemoryDetailViewModel()
    @State private var scale: CGFloat = 1
    @State private var isDown: Bool = false
    @State private var showingSheet = false
    @State private var showingAlert = false
    @State private var isPresented: Bool = false
    
    private var memory: Memory
    
    init(
        memory: Memory
    ) {
        self.memory = memory
    }
    
    var body: some View {
        CBScaleScrollView(
            isPresented: self.$appModel.showDetailView,
            scale: self.$scale,
            isDown: self.$isDown
        ) {
            VStack(spacing: 20) {
                self.PhotoView()
                self.ContentView()
            }
        }
        .overlay(alignment: .top, content: DetailHeaderView)
        .background(Color.backgroundNormalNormal)
        .clipShape(RoundedRectangle(cornerRadius: scale == 1 ? 0 : 30))
        .scaleEffect(self.scale)
        .ignoresSafeArea()
        .actionSheet(isPresented: self.$showingSheet) {
            ActionSheet(
                title: Text("원하는 옵션을 선택해주세요."),
                message: nil,
                buttons: [
                    .default(Text("편집")) {
                        self.isPresented = true
                    },
                    .destructive(Text("삭제")) {
                        self.showingAlert = true
                    },
                    .cancel(Text("취소"))
                ]
            )
        }
        .alert(isPresented: self.$showingAlert) {
            Alert(
                title: Text("추억을 삭제하시겠습니까?"),
                message: nil,
                primaryButton: .destructive(
                    Text("삭제"),
                    action: {
                        self.viewModel.removeMemory(memory: self.memory)
                        withAnimation(.spring()) {
                            self.appModel.showDetailView = false
                        }
                    }
                ),
                secondaryButton: .cancel(Text("취소"))
            )
        }
        .fullScreenCover(isPresented: self.$isPresented) {
            EditMemoryContentView(memory: self.memory)
        }
    }
    
    @ViewBuilder
    func DetailHeaderView() -> some View {
        HStack {
            Button {
                withAnimation(.spring()) {
                    self.appModel.showDetailView = false
                }
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(isDown ? Color.white.opacity(0.8) : Color.black.opacity(0.7))
                    .padding()
                    .background(isDown ? Color.black.opacity(0.7) : Color.white.opacity(0.8))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            Button {
                isPresented = true
            } label: {
                Image(systemName: "suit.heart.fill")
                    .foregroundColor(isDown ? Color.white.opacity(0.8) : Color.black.opacity(0.7))
                    .padding()
                    .background(isDown ? Color.black.opacity(0.7) : Color.white.opacity(0.8))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, BaseSize.horizantalPadding)
        .padding(.top, BaseSize.topAreaPadding + 10)
    }
    
    @ViewBuilder
    private func PhotoView() -> some View {
        TabView {
            ForEach(self.memory.photos.compactMap { $0.image }, id: \.self) { photo in
                Image(uiImage: photo)
                    .resizable()
                    .scaledToFill()
                    .frame(width: BaseSize.screenWidth, height: BaseSize.screenWidth)
                    .clipped()
            }
        }
        .background(Color.backgroundNormalAlternative)
        .frame(width: BaseSize.screenWidth, height: BaseSize.screenWidth)
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
    
    @ViewBuilder
    private func ContentView() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(self.memory.title)
                    .font(.pretendard(size: 20, weight: .bold))
                    .foregroundStyle(Color.labelNormal)
                
                Text(self.memory.date.format("MMM d, yyyy"))
                    .font(.pretendard(size: 14, weight: .medium))
                    .foregroundStyle(Color.labelAlternative)
            }
            
            CBDivider()
            
            Text(self.memory.note)
                .font(.pretendard(size: 14, weight: .regular))
                .foregroundColor(Color.labelNormal)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, BaseSize.horizantalPadding)
    }
}
