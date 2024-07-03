//
//  MapRepresentableView.swift
//  CobyHappiness
//
//  Created by Coby Kim on 6/10/24.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapRepresentableView: UIViewRepresentable {
    
    @Binding var memories: [MemoryModel]
    @Binding var filteredMemories: [MemoryModel]
    
    init(
        memories: Binding<[MemoryModel]>,
        filteredMemories: Binding<[MemoryModel]>
    ) {
        self._memories = memories
        self._filteredMemories = filteredMemories
    }
    
    class Coordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
        var parent: MapRepresentableView
        var mapView: MKMapView?
        var isInitialLocationSet = false
        
        init(parent: MapRepresentableView) {
            self.parent = parent
            super.init()
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
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            let topLeft = mapView.convert(CGPoint(x: 0, y: 0), toCoordinateFrom: mapView)
            let bottomRight = mapView.convert(CGPoint(x: mapView.frame.width, y: mapView.frame.height), toCoordinateFrom: mapView)
            
            self.parent.filteredMemories = self.parent.memories.compactMap { memory in
                if let location = memory.location?.coordinate {
                    if location.latitude <= topLeft.latitude && location.latitude >= bottomRight.latitude &&
                        location.longitude >= topLeft.longitude && location.longitude <= bottomRight.longitude {
                        return memory
                    }
                }
                return nil
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        context.coordinator.mapView = mapView
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let allAnnotations = uiView.annotations
        uiView.removeAnnotations(allAnnotations)
        
        for memory in self.memories {
            if let coordinate = memory.location?.coordinate {
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = memory.title
                uiView.addAnnotation(annotation)
            }
        }
    }
}
