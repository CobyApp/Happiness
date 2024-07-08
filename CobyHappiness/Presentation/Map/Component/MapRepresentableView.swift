//
//  MapRepresentableView.swift
//  CobyHappiness
//
//  Created by Coby Kim on 6/10/24.
//

import SwiftUI
import MapKit

import CobyDS

// Custom Annotation Class
class MemoryAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var image: UIImage?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, image: UIImage?) {
        self.coordinate = coordinate
        self.title = title
        self.image = image
    }
}

// Custom Annotation View Class
class MemoryAnnotationView: MKAnnotationView {
    static let reuseIdentifier = "MemoryAnnotationView"
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let memoryAnnotation = newValue as? MemoryAnnotation else { return }
            
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            if let image = memoryAnnotation.image {
                iconImageView?.image = image.withRenderingMode(.alwaysTemplate)
                iconImageView?.tintColor = .white
            } else {
                iconImageView?.image = nil
            }
        }
    }
    
    private var iconImageView: UIImageView?
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        // Circle background
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        backgroundView.backgroundColor = UIColor(Color.staticBlack)
        backgroundView.layer.cornerRadius = 20
        backgroundView.layer.masksToBounds = true
        
        // Add border to backgroundView
        backgroundView.layer.borderColor = UIColor(Color.lineNormalNormal).cgColor
        backgroundView.layer.borderWidth = 1.0
        
        // White icon
        let iconImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = UIColor(Color.staticWhite)
        
        backgroundView.addSubview(iconImageView)
        addSubview(backgroundView)
        
        self.iconImageView = iconImageView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        subviews.first?.center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        iconImageView?.center = CGPoint(x: 20, y: 20) // Center the icon within the circle
    }
}

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
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let annotation = annotation as? MemoryAnnotation else { return nil }
            
            let annotationView: MemoryAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: MemoryAnnotationView.reuseIdentifier) as? MemoryAnnotationView {
                dequeuedView.annotation = annotation
                annotationView = dequeuedView
            } else {
                annotationView = MemoryAnnotationView(annotation: annotation, reuseIdentifier: MemoryAnnotationView.reuseIdentifier)
                annotationView.annotation = annotation
            }
            return annotationView
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
        
        let annotations = self.memories.compactMap { memory -> MemoryAnnotation? in
            guard let coordinate = memory.location?.toCLLocationCoordinate2D() else { return nil }
            return MemoryAnnotation(
                coordinate: coordinate,
                title: memory.title,
                image: memory.type.icon
            )
        }
        
        mapView.addAnnotations(annotations)
    }
}
