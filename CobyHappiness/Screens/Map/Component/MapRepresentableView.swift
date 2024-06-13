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
    
    @Binding var topLeft: CLLocationCoordinate2D
    @Binding var bottomRight: CLLocationCoordinate2D
    
    private var memories: [Memory]
    
    init(
        topLeft: Binding<CLLocationCoordinate2D>,
        bottomRight: Binding<CLLocationCoordinate2D>,
        memories: [Memory]
    ) {
        self._topLeft = topLeft
        self._bottomRight = bottomRight
        self.memories = memories
    }
    
    class Coordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
        var parent: MapRepresentableView
        var locationManager: CLLocationManager?
        var mapView: MKMapView?
        var isInitialLocationSet = false
        
        init(parent: MapRepresentableView) {
            self.parent = parent
            super.init()
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.requestWhenInUseAuthorization()
            locationManager?.startUpdatingLocation()
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
            self.parent.topLeft = mapView.convert(CGPoint(x: 0, y: 0), toCoordinateFrom: mapView)
            self.parent.bottomRight = mapView.convert(CGPoint(x: mapView.frame.width, y: mapView.frame.height), toCoordinateFrom: mapView)
            print("Top Left: \(parent.topLeft)")
            print("Bottom Right: \(parent.bottomRight)")
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.first, !isInitialLocationSet else { return }
            isInitialLocationSet = true
            
            let center = location.coordinate
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            
            DispatchQueue.main.async {
                self.mapView?.setRegion(region, animated: true)
                
                self.parent.topLeft = CLLocationCoordinate2D(
                    latitude: center.latitude + region.span.latitudeDelta / 2,
                    longitude: center.longitude - region.span.longitudeDelta / 2
                )
                self.parent.bottomRight = CLLocationCoordinate2D(
                    latitude: center.latitude - region.span.latitudeDelta / 2,
                    longitude: center.longitude + region.span.longitudeDelta / 2
                )
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
