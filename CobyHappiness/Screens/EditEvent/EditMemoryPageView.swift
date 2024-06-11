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
    
    @State private var selectionMade = false
    
    @State private var selectedImages: [UIImage] = []
    @State private var date: Date = Date.now
    @State private var location: Location? = nil

    var body: some View {
        TabView(selection: $selectionMade) {
            ImagePickerView(
                didFinishPicking: { imagesWithMetadata in
                    for (image, date, location) in imagesWithMetadata {
                        self.selectedImages.append(image)
                        
                        if let date = date, let coordinate = location?.coordinate {
                            self.date = date
                            self.location = Location(lat: coordinate.latitude, lon: coordinate.longitude)
                        }
                    }
                    
                    selectionMade = true
                },
                didCancel: {
                    self.dismiss()
                }
            )
            .edgesIgnoringSafeArea(.all)
            .tag(false)

            EditMemoryView(
                selectionMade: $selectionMade,
                selectedImages: $selectedImages,
                date: $date,
                location: $location
            )
            .tag(true)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .background(Color.backgroundNormalNormal)
    }
}

#Preview {
    EditMemoryPageView()
}
