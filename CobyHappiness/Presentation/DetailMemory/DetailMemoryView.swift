//
//  DetailMemoryView.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 10/4/23.
//

import SwiftUI

import CobyDS
import ComposableArchitecture

struct DetailMemoryView: View {
    
    @Bindable private var store: StoreOf<DetailMemoryStore>
    
    init(store: StoreOf<DetailMemoryStore>) {
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
                    PhotoView(photos: self.store.memory.photos)
                    
                    ContentView(memory: self.store.memory)
                    
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
        .navigationDestination(
            item: self.$store.scope(state: \.editMemory, action: \.editMemory)
        ) { store in
            EditMemoryView(store: store).navigationBarHidden(true)
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
    private func ContentView(memory: MemoryModel) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(memory.title)
                    .font(.pretendard(size: 20, weight: .semibold))
                    .foregroundStyle(Color.labelNormal)
                
                Text(memory.date.format("yy.MM.dd"))
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
