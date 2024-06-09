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
    @Environment(\.modelContext) private var context
    
    @State private var showingSheet = false
    @State private var showingAlert = false
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
                },
                rightSide: .icon,
                rightIcon: Image("more"),
                rightAction: {
                    self.showingSheet = true
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
        .actionSheet(isPresented: self.$showingSheet) {
            ActionSheet(
                title: Text("원하는 옵션을 선택해주세요."),
                message: nil,
                buttons: [
                    .default(Text("추억 편집하기")) {
                        self.isPresented = true
                    },
                    .destructive(Text("추억 삭제하기")) {
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
                        self.context.delete(self.event)
                        self.dismiss()
                    }
                ),
                secondaryButton: .cancel(Text("취소"))
            )
        }
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
        VStack(alignment: .leading, spacing: 8) {
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
