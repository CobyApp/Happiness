//
//  MemoryDetailView.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 10/4/23.
//

import SwiftUI

import CobyDS
import ComposableArchitecture

struct MemoryDetailView: View {
    
    @EnvironmentObject private var appModel: AppViewModel
    
    @State private var scale: CGFloat = 1
    @State private var isDown: Bool = false
    
    private let store: StoreOf<MemoryDetailStore>
    
    init(store: StoreOf<MemoryDetailStore>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            CBScaleScrollView(
                isPresented: self.$appModel.showDetailView,
                scale: self.$scale,
                isDown: self.$isDown
            ) {
                VStack(spacing: 20) {
                    self.PhotoView(photos: viewStore.photos)
                    self.ContentView(memory: viewStore.memory ?? .init())
                }
            }
            .overlay(
                alignment: .top,
                content: {
                    DetailHeaderView(viewStore: viewStore)
                }
            )
            .background(Color.backgroundNormalNormal)
            .clipShape(RoundedRectangle(cornerRadius: scale == 1 ? 0 : 30))
            .scaleEffect(self.scale)
            .ignoresSafeArea()
            .actionSheet(isPresented: viewStore.$showingSheet) {
                ActionSheet(
                    title: Text("원하는 옵션을 선택해주세요."),
                    message: nil,
                    buttons: [
                        .default(Text("편집")) {
                            viewStore.send(.showEditMemory)
                        },
                        .destructive(Text("삭제")) {
                            viewStore.send(.showDeleteAlert)
                        },
                        .cancel(Text("취소"))
                    ]
                )
            }
            .alert(isPresented: viewStore.$showingAlert) {
                Alert(
                    title: Text("추억을 삭제하시겠습니까?"),
                    message: nil,
                    primaryButton: .destructive(
                        Text("삭제"),
                        action: {
                            viewStore.send(.removeMemory(viewStore.memory ?? .init()))
                            viewStore.send(.closeMemoryDetail)
                        }
                    ),
                    secondaryButton: .cancel(Text("취소"))
                )
            }
            .fullScreenCover(isPresented: viewStore.$showingEditMemoryView) {
                EditMemoryView(viewModel: EditMemoryViewModel(memory: viewStore.memory))
            }
            .onAppear {
                viewStore.send(.onAppear(self.appModel))
            }
        }
    }
    
    @ViewBuilder
    func DetailHeaderView(viewStore: ViewStore<MemoryDetailStore.State, MemoryDetailStore.Action>) -> some View {
        HStack {
            Button {
                viewStore.send(.closeMemoryDetail)
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
                viewStore.send(.showOptionSheet)
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
    private func PhotoView(photos: [UIImage]) -> some View {
        TabView {
            ForEach(photos, id: \.self) { photo in
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
    private func ContentView(memory: MemoryModel) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(memory.title)
                    .font(.pretendard(size: 20, weight: .semibold))
                    .foregroundStyle(Color.labelNormal)
                
                Text(memory.date.format("MMM d, yyyy"))
                    .font(.pretendard(size: 14, weight: .regular))
                    .foregroundStyle(Color.labelAlternative)
            }
            
            CBDivider()
            
            Text(memory.note)
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
