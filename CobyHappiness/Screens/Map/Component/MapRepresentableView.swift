//
//  MapRepresentableView.swift
//  CobyHappiness
//
//  Created by Coby Kim on 6/10/24.
//

import SwiftUI
import MapKit

struct MapRepresentableView: UIViewRepresentable {
    
    private var memories: [Memory]
    
    init(
        memories: [Memory]
    ) {
        self.memories = memories
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapRepresentableView
        
        init(parent: MapRepresentableView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "marker") {
                annotationView.annotation = annotation
                return annotationView
            } else {
                let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "marker")
                annotationView.canShowCallout = true
                return annotationView
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let allAnnotations = uiView.annotations
        uiView.removeAnnotations(allAnnotations)
        
        for memory in memories {
            if let coordinate = memory.location?.coordinate {
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = memory.title
                uiView.addAnnotation(annotation)
            }
        }
    }
}
