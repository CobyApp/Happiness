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
        var locationManager = CLLocationManager()
        
        init(parent: MapRepresentableView) {
            self.parent = parent
            super.init()
            self.locationManager.delegate = self
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            self.filterMemoriesInVisibleRegion(mapView)
        }
        
        private func filterMemoriesInVisibleRegion(_ mapView: MKMapView) {
            let topLeftCoordinate = mapView.convert(CGPoint(x: 0, y: 0), toCoordinateFrom: mapView)
            let bottomRightCoordinate = mapView.convert(CGPoint(x: mapView.frame.width, y: mapView.frame.height), toCoordinateFrom: mapView)
            
            self.parent.filteredMemories = self.parent.memories.filter { memory in
                guard let location = memory.location?.coordinate else { return false }
                return location.latitude <= topLeftCoordinate.latitude &&
                location.latitude >= bottomRightCoordinate.latitude &&
                location.longitude >= topLeftCoordinate.longitude &&
                location.longitude <= bottomRightCoordinate.longitude
            }
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
            guard let coordinate = memory.location?.coordinate else { return nil }
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = memory.title
            return annotation
        }
        
        mapView.addAnnotations(annotations)
    }
}
