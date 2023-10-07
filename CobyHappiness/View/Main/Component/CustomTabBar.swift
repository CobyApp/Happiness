//
//  CustomTabBar.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 10/4/23.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var currentTab: Tab
    @State var currentXValue: CGFloat = 0
    
    var animation: Namespace.ID
    
    var body: some View {
        HStack(spacing: 0){
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                TabButton(tab: tab)
                    .overlay {
                        Text(tab.rawValue)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.black)
                            .offset(y: currentTab == tab ? 15 : 100)
                    }
            }
        }
        .padding(.top)
        // Preview wont show safeArea...
        .padding(.bottom,getSafeArea().bottom == 0 ? 15 : 10)
        .background{
            Color.white
                .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: -5)
                .clipShape(BottomCurve(currentXValue: currentXValue))
                .ignoresSafeArea(.container, edges: .bottom)
        }
    }
    
    @ViewBuilder
    func TabButton(tab: Tab)->some View{
        GeometryReader{proxy in
            Button {
                withAnimation(.easeInOut){
                    currentTab = tab
                    currentXValue = proxy.frame(in: .global).midX
                }
                
            } label: {
                Image(systemName: "house")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(currentTab == tab ? .white : .gray.opacity(0.8))
                    .padding(currentTab == tab ? 15 : 0)
                    .background(
                        ZStack {
                            if currentTab == tab {
                                Circle()
                                    .fill(Color.black)
                                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 5, y: 5)
                                    .matchedGeometryEffect(id: "TAB", in: animation)
                            }
                        }
                    )
                    .contentShape(Rectangle())
                    .offset(y: currentTab == tab ? -50 : 0)
            }
            .onAppear {
                if tab == Tab.allCases.first && currentXValue == 0 {
                    currentXValue = proxy.frame(in: .global).midX
                }
            }
        }
        .frame(height: 30)
    }
}

// MARK: Tabs
enum Tab: String,CaseIterable {
    case home = "Home"
    case cart = "Cart"
    case favourite = "Star"
    case profile = "Profile"
}

// Getting Safe Area...
extension View {
    func getSafeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        
        return safeArea
    }
}
