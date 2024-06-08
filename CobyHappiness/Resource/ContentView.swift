//
//  ContentView.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 10/4/23.
//

import SwiftUI

import CobyDS

struct ContentView: View {
    
    @StateObject var appModel: AppViewModel = .init()
    
    @Namespace var animation
    
    var body: some View {
        ZStack {
            TabView {
                Home(animation: animation)
                    .tabItem {
                        Label("홈", image: "home")
                    }
                
                Home(animation: animation)
                    .tabItem {
                        Label("지도", image: "map")
                    }
                
                Home(animation: animation)
                    .tabItem {
                        Label("여행", image: "travel")
                    }
                
                Home(animation: animation)
                    .tabItem {
                        Label("정보", image: "person")
                    }
            }
            .opacity(appModel.showDetailView ? 0 : 1)
            
            if let event = appModel.currentActiveItem, appModel.showDetailView {
                Detail(event: event, animation: animation)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundNormalNormal)
        .environmentObject(appModel)
        .modelContainer(for: Event.self)
    }
}
