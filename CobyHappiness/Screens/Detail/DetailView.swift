//
//  DetailView.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 10/4/23.
//

import SwiftUI

import CobyDS

struct DetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var isPresented: Bool = false
    @State private var photos = [UIImage]()
    
    private var event: Event
    
    init(event: Event) {
        self.event = event
        self._photos = State(wrappedValue: event.photos.compactMap { UIImage(data: $0.image) })
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(
                leftSide: .left,
                leftAction: {
                    self.dismiss()
                }
            )
            
            ScrollView {
                VStack(spacing: 20) {
                    self.PhotoView()
                    
                    self.ContentView()
                }
            }
        }
        .padding(.bottom, BaseSize.bottomAreaPadding + 20)
        .background(Color.backgroundNormalNormal)
        .edgesIgnoringSafeArea(.bottom)
        .fullScreenCover(isPresented: self.$isPresented) {
            EditView(event: self.event)
        }
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
            }
        }
        .frame(width: BaseSize.screenWidth, height: BaseSize.screenWidth)
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .onAppear {
            UIScrollView.appearance().bounces = false
        }
    }
    
    @ViewBuilder
    private func ContentView() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            self.TitleView()
            
            CBDivider()
            
            self.NoteView()
        }
        .padding(.horizontal, BaseSize.horizantalPadding)
    }
    
    private func TitleView() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(self.event.title)
                .font(.pretendard(size: 20, weight: .bold))
                .foregroundStyle(Color.labelNormal)
            
            Text(self.event.date.format("MMM d, yyyy"))
                .font(.pretendard(size: 14, weight: .medium))
                .foregroundStyle(Color.labelAlternative)
        }
    }
    
    private func NoteView() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("기록")
                .font(.pretendard(size: 18, weight: .bold))
                .foregroundStyle(Color.labelNormal)
            
            Text(self.event.note)
                .font(.pretendard(size: 14, weight: .regular))
                .foregroundColor(Color.labelNormal)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
