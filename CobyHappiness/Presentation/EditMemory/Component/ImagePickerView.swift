//
//  ImagePickerView.swift
//  CobyHappiness
//
//  Created by Coby on 6/11/24.
//

import SwiftUI
import PhotosUI
import ImageIO
import CoreLocation

struct ImagePickerView: UIViewControllerRepresentable {

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePickerView
        
        init(parent: ImagePickerView) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard !results.isEmpty else {
                self.parent.didCancel?()
                return
            }
            
            var imagesWithMetadata: [(UIImage, Date?, CLLocation?)] = []
            let group = DispatchGroup()
            
            for result in results {
                let provider = result.itemProvider
                
                if provider.canLoadObject(ofClass: UIImage.self) {
                    group.enter()
                    provider.loadObject(ofClass: UIImage.self) { (image, error) in
                        if let image = image as? UIImage {
                            self.loadMetadata(for: provider, image: image) { metadata in
                                imagesWithMetadata.append(metadata)
                                group.leave()
                            }
                        } else {
                            group.leave()
                        }
                    }
                }
            }
            
            group.notify(queue: .main) {
                self.parent.didFinishPicking?(imagesWithMetadata)
            }
        }
        
        private func loadMetadata(for provider: NSItemProvider, image: UIImage, completion: @escaping ((UIImage, Date?, CLLocation?)) -> Void) {
            provider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { url, error in
                guard let url = url else {
                    completion((image, nil, nil))
                    return
                }
                
                let source = CGImageSourceCreateWithURL(url as CFURL, nil)
                let properties = CGImageSourceCopyPropertiesAtIndex(source!, 0, nil) as Dictionary?
                
                let exif = properties?[kCGImagePropertyExifDictionary as String as NSObject] as? [String: Any]
                let tiff = properties?[kCGImagePropertyTIFFDictionary as String as NSObject] as? [String: Any]
                
                let creationDateString = exif?[kCGImagePropertyExifDateTimeOriginal as String] as? String ?? tiff?[kCGImagePropertyTIFFDateTime as String] as? String
                let creationDate = creationDateString.flatMap { dateString in
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy:MM:dd HH:mm:ss"
                    return formatter.date(from: dateString)
                }
                
                let gps = properties?[kCGImagePropertyGPSDictionary as String as NSObject] as? [String: Any]
                let latitude = gps?[kCGImagePropertyGPSLatitude as String] as? Double
                let longitude = gps?[kCGImagePropertyGPSLongitude as String] as? Double
                let location: CLLocation? = {
                    if let latitude = latitude, let longitude = longitude {
                        return CLLocation(latitude: latitude, longitude: longitude)
                    }
                    return nil
                }()
                
                completion((image, creationDate, location))
            }
        }
    }
    
    var didFinishPicking: (([(UIImage, Date?, CLLocation?)]) -> Void)?
    var didCancel: (() -> Void)?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 0 // 0 means no limit
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
}
