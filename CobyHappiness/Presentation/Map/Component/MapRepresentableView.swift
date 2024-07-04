//
//  MapRepresentableView.swift
//  CobyHappiness
//
//  Created by Coby Kim on 6/10/24.
//

import SwiftUI
import MapKit

struct MapRepresentableView: UIViewRepresentable {
    
    @Binding var memories: [MemoryModel]
    @Binding var topLeft: LocationModel?
    @Binding var bottomRight: LocationModel?
    
    init(
        memories: Binding<[MemoryModel]>,
        topLeft: Binding<LocationModel?>,
        bottomRight: Binding<LocationModel?>
    ) {
        self._memories = memories
        self._topLeft = topLeft
        self._bottomRight = bottomRight
    }
    
    class Coordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
        var parent: MapRepresentableView
        var mapView: MKMapView?
        var locationManager = CLLocationManager()
        
        init(parent: MapRepresentableView) {
            self.parent = parent
            super.init()
            self.locationManager.delegate = self
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            self.parent.topLeft = mapView.convert(CGPoint(x: 0, y: 0), toCoordinateFrom: mapView).toLocationModel()
            self.parent.bottomRight = mapView.convert(CGPoint(x: mapView.frame.width, y: mapView.frame.height), toCoordinateFrom: mapView).toLocationModel()
        }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                self.locationManager.startUpdatingLocation()
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.first {
                let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                let region = MKCoordinateRegion(center: location.coordinate, span: span)
                mapView?.setRegion(region, animated: true)
                self.locationManager.stopUpdatingLocation() // 위치 업데이트 중지
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        context.coordinator.mapView = mapView
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        self.addMarkersToMapView(uiView)
    }
    
    private func addMarkersToMapView(_ mapView: MKMapView) {
        mapView.removeAnnotations(mapView.annotations)
        
        let annotations = self.memories.compactMap { memory -> MKPointAnnotation? in
            guard let coordinate = memory.location?.toCLLocationCoordinate2D() else { return nil }
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = memory.title
            return annotation
        }
        
        mapView.addAnnotations(annotations)
    }
}
