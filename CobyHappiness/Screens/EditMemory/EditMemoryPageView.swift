//
//  EditMemoryPageView.swift
//  CobyHappiness
//
//  Created by Coby on 6/11/24.
//

import SwiftUI
import MapKit

import CobyDS

struct EditMemoryPageView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var selection = 0
    @State private var selectedImages: [UIImage] = []
    @State private var date: Date = Date.now
    @State private var location: Location? = nil

    var body: some View {
        TabView(selection: self.$selection) {
            ImagePickerView(
                didFinishPicking: { imagesWithMetadata in
                    self.selectedImages = imagesWithMetadata.map { $0.0 }
                    self.date = imagesWithMetadata.map { $0.1 ?? .now }.first ?? .now
                    self.location = imagesWithMetadata.map {
                        if let coordinate = $0.2?.coordinate {
                            Location(lat: coordinate.latitude, lon: coordinate.longitude)
                        } else {
                            nil
                        }
                    }.first ?? nil
                    
                    self.selection = 1
                },
                didCancel: {
                    self.dismiss()
                }
            )
            .edgesIgnoringSafeArea(.all)
            .tag(0)

            EditMemoryView(
                selection: $selection,
                selectedImages: $selectedImages,
                date: $date,
                location: $location
            )
            .tag(1)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .background(Color.backgroundNormalNormal)
    }
}

#Preview {
    EditMemoryPageView()
}
