//
//  DetailView.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 10/4/23.
//

import SwiftUI

import CobyDS

struct DetailView: View {
    
    @Environment(\.namespace) private var animation
    
    @EnvironmentObject private var appModel: AppViewModel
    
    @State private var isPresented: Bool = false
    @State private var scale: CGFloat = 1
    @State private var isDown: Bool = false
    @State private var photos = [UIImage]()
    
    private var event: Event
    
    init(event: Event) {
        self.event = event
        self._photos = State(wrappedValue: event.photos.compactMap { UIImage(data: $0.image) })
    }
    
    var body: some View {
        CBScaleScrollView(
            isPresented: self.$appModel.showDetailView,
            scale: self.$scale,
            isDown: self.$isDown
        ) {
            VStack(spacing: 0) {
                self.DetailPhoto()
                self.DetailContent()
            }
        }
        .overlay(alignment: .top, content: self.DetailHeader)
        .background(Color.backgroundNormalNormal)
        .clipShape(RoundedRectangle(cornerRadius: self.scale == 1 ? 0 : 30))
        .scaleEffect(self.scale)
        .ignoresSafeArea()
        .sheet(isPresented: self.$isPresented) {
            EventEditView(event: self.event)
        }
    }
    
    @ViewBuilder
    private func DetailHeader() -> some View {
        HStack {
            Button {
                withAnimation(.spring()) {
                    self.appModel.showDetailView = false
                }
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(self.isDown ? Color.white.opacity(0.8) : Color.black.opacity(0.7))
                    .padding()
                    .background(self.isDown ? Color.black.opacity(0.7) : Color.white.opacity(0.8))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            Button {
                self.isPresented = true
            } label: {
                Image(systemName: "suit.heart.fill")
                    .foregroundColor(self.isDown ? Color.white.opacity(0.8) : Color.black.opacity(0.7))
                    .padding()
                    .background(self.isDown ? Color.black.opacity(0.7) : Color.white.opacity(0.8))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, BaseSize.horizantalPadding)
        .padding(.top, BaseSize.topAreaPadding + 10)
    }
    
    @ViewBuilder
    private func DetailPhoto() -> some View {
        TabView {
            ForEach(self.photos, id: \.self) { photo in
                Image(uiImage: photo)
                    .resizable()
                    .scaledToFill()
                    .frame(width: BaseSize.screenWidth, height: BaseSize.screenWidth * 1.2)
                    .clipped()
                    .ignoresSafeArea()
            }
        }
        .frame(width: BaseSize.screenWidth, height: BaseSize.screenWidth * 1.2)
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .matchedGeometryEffect(id: "image" + self.event.id.uuidString, in: self.animation)
        .onAppear {
            UIScrollView.appearance().bounces = false
        }
    }
    
    @ViewBuilder
    private func DetailContent() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            self.headerView()
            
            CBDivider()
            
            self.noteView()
        }
        .padding(.horizontal, BaseSize.horizantalPadding)
        .padding(.top, 20)
        .padding(.bottom, BaseSize.bottomAreaPadding + 20)
        .background(Color.backgroundNormalNormal)
        .animation(nil, value: UUID())
    }
    
    private func headerView() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(self.event.title)
                .font(.title.bold())
                .foregroundStyle(Color.labelNormal)
                .matchedGeometryEffect(id: "title" + self.event.id.uuidString, in: self.animation)
            
            Text(self.event.date.format("MMM d, yyyy"))
                .font(.callout.bold())
                .foregroundStyle(Color.labelAlternative)
                .matchedGeometryEffect(id: "note" + self.event.id.uuidString, in: self.animation)
        }
    }
    
    private func noteView() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("기록")
                .font(.title3.bold())
                .foregroundStyle(Color.labelNormal)
            
            Text(self.event.note)
                .font(.callout)
                .foregroundColor(Color.labelNormal)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
