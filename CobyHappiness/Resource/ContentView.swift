//
//  ContentView.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 10/4/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var appModel: AppViewModel = .init()
    
    @Namespace var animation
    
    var body: some View {
        Home(animation: animation)
            .background {
                Color(Color.backgroundLightGray)
                    .ignoresSafeArea()
            }
            .environmentObject(appModel)
            .overlay {
                if let event = appModel.currentActiveItem, appModel.showDetailView {
                    Detail(event: event, animation: animation)
                        .environmentObject(appModel)
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .modelContainer(for: Event.self)
    }
}
