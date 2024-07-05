//
//  DetailBunchView.swift
//  CobyHappiness
//
//  Created by Coby on 6/12/24.
//

import SwiftUI

import CobyDS
import ComposableArchitecture

struct DetailBunchView: View {
    
    @Bindable private var store: StoreOf<DetailBunchStore>
    
    init(store: StoreOf<DetailBunchStore>) {
        self.store = store
    }
    
    var body: some View {
        ZStack {
            Color.backgroundNormalAlternative
                .edgesIgnoringSafeArea(.all)
            
            CBScaleScrollView(
                isPresented: self.$store.isPresented,
                scale: self.$store.scale,
                isDown: self.$store.isDown
            ) {
                VStack(spacing: 20) {
                    PhotoView(photos: self.store.bunch.photos)
                    
                    ContentView(bunch: self.store.bunch)
                    
                    Spacer()
                }
            }
            .overlay(
                alignment: .top,
                content: {
                    DetailHeaderView()
                }
            )
            .background(Color.backgroundNormalNormal)
            .clipShape(RoundedRectangle(cornerRadius: self.store.scale == 1 ? 0 : 30))
            .scaleEffect(self.scale)
            .ignoresSafeArea()
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color.backgroundNormalNormal)
        .navigationDestination(
            item: self.$store.scope(state: \.detailMemory, action: \.detailMemory)
        ) { store in
            DetailMemoryView(store: store).navigationBarHidden(true)
        }
        .navigationDestination(
            item: self.$store.scope(state: \.editBunch, action: \.editBunch)
        ) { store in
            EditBunchView(store: store).navigationBarHidden(true)
        }
        .confirmationDialog(
            self.$store.scope(state: \.optionSheet, action: \.optionSheet)
        )
        .alert(
            self.$store.scope(state: \.deleteAlert, action: \.deleteAlert)
        )
    }
    
    @ViewBuilder
    func DetailHeaderView() -> some View {
        HStack {
            Button {
                self.store.send(.dismiss)
            } label: {
                Image(uiImage: UIImage.icBack)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(self.store.isDown ? Color.white.opacity(0.8) : Color.black.opacity(0.7))
                    .padding()
                    .background(self.store.isDown ? Color.black.opacity(0.7) : Color.white.opacity(0.8))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            Button {
                self.store.send(.showOptionSheet)
            } label: {
                Image(uiImage: UIImage.icMore)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(self.store.isDown ? Color.white.opacity(0.8) : Color.black.opacity(0.7))
                    .padding()
                    .background(self.store.isDown ? Color.black.opacity(0.7) : Color.white.opacity(0.8))
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
    private func ContentView(bunch: BunchModel) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(bunch.title)
                    .font(.pretendard(size: 20, weight: .semibold))
                    .foregroundStyle(Color.labelNormal)
                
                Text(bunch.term)
                    .font(.pretendard(size: 14, weight: .regular))
                    .foregroundStyle(Color.labelAlternative)
            }
            
            CBDivider()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("목록")
                    .font(.pretendard(size: 16, weight: .semibold))
                    .foregroundColor(Color.labelNormal)
                
                MemoryListView(memories: bunch.memories)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, BaseSize.horizantalPadding)
    }
    
    @ViewBuilder
    private func MemoryListView(memories: [MemoryModel]) -> some View {
        if memories.isEmpty {
            EmptyMemoryView(
                showingButton: false
            )
            .padding(.top, -100)
        } else {
            LazyVStack(spacing: 8) {
                ForEach(memories) { memory in
                    MemoryTileView(
                        memory: memory
                    )
                    .onTapGesture {
                        self.store.send(.showDetailMemory(memory))
                    }
                }
            }
        }
    }
}
