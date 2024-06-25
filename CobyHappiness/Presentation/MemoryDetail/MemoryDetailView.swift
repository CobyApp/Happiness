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
    
    @StateObject private var viewModel: MemoryDetailViewModel
    
    @State private var scale: CGFloat = 1
    @State private var isDown: Bool = false
    @State private var showingSheet = false
    @State private var showingAlert = false
    @State private var isPresented: Bool = false
    
    @State private var photos = [UIImage]()
    
    private var memory: MemoryModel
    
    init(
        viewModel: MemoryDetailViewModel,
        memory: MemoryModel
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._photos = State(wrappedValue: memory.photos.compactMap { $0.image })
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
                        self.appModel.showDetailView = false
                    }
                ),
                secondaryButton: .cancel(Text("취소"))
            )
        }
        .fullScreenCover(isPresented: self.$isPresented) {
            EditMemoryContentView(viewModel: EditMemoryViewModel(), memory: self.memory)
        }
    }
    
    @ViewBuilder
    func DetailHeaderView() -> some View {
        HStack {
            Button {
                self.appModel.showDetailView = false
            } label: {
                Image(uiImage: UIImage.icBack)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(self.isDown ? Color.white.opacity(0.8) : Color.black.opacity(0.7))
                    .padding()
                    .background(self.isDown ? Color.black.opacity(0.7) : Color.white.opacity(0.8))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            Button {
                self.showingSheet = true
            } label: {
                Image(uiImage: UIImage.icMore)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(self.isDown ? Color.white.opacity(0.8) : Color.black.opacity(0.7))
                    .padding()
                    .background(self.isDown ? Color.black.opacity(0.7) : Color.white.opacity(0.8))
                    .clipShape(Circle())
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, BaseSize.horizantalPadding)
        .padding(.top, BaseSize.topAreaPadding + 10)
    }
    
    @ViewBuilder
    private func PhotoView() -> some View {
        TabView {
            ForEach(self.photos, id: \.self) { photo in
                Image(uiImage: photo)
                    .resizable()
                    .scaledToFill()
                    .frame(width: BaseSize.screenWidth, height: BaseSize.screenWidth)
                    .clipped()
                    .ignoresSafeArea()
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
                    .font(.pretendard(size: 20, weight: .semibold))
                    .foregroundStyle(Color.labelNormal)
                
                Text(self.memory.date.format("MMM d, yyyy"))
                    .font(.pretendard(size: 14, weight: .regular))
                    .foregroundStyle(Color.labelAlternative)
            }
            
            CBDivider()
            
            Text(self.memory.note)
                .font(.pretendard(size: 16, weight: .regular))
                .foregroundColor(Color.labelNormal)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, BaseSize.horizantalPadding)
    }
}
