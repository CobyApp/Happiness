//
//  ContentView.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 10/4/23.
//

import SwiftUI

import CobyDS

struct ContentView: View {
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("홈", image: "home")
                }
            
            MapView()
                .tabItem {
                    Label("지도", image: "map")
                }
            
            BunchView()
                .tabItem {
                    Label("뭉치", image: "travel")
                }
            
            ProfileView()
                .tabItem {
                    Label("정보", image: "person")
                }
        }
    }
}
