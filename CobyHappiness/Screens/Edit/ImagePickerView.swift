//
//  ImagePickerView.swift
//  CobyHappiness
//
//  Created by Coby on 6/11/24.
//

import SwiftUI
import PhotosUI

struct ImagePickerView: UIViewControllerRepresentable {
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePickerView
        
        init(parent: ImagePickerView) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            if results.isEmpty {
                // '취소' 버튼이 눌렸을 때
                self.parent.didCancel?()
            } else {
                // '추가' 버튼이 눌렸을 때
                var imagesWithMetadata: [(UIImage, Date?, CLLocation?)] = []
                let group = DispatchGroup()
                
                for result in results {
                    group.enter()
                    let provider = result.itemProvider
                    var tempImage: UIImage?
                    
                    if provider.canLoadObject(ofClass: UIImage.self) {
                        provider.loadObject(ofClass: UIImage.self) { (image, error) in
                            if let image = image as? UIImage {
                                tempImage = image
                            }
                            group.leave()
                        }
                    } else {
                        group.leave()
                    }
                    
                    group.enter()
                    if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                        provider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { url, error in
                            if url != nil {
                                let assetResults = PHAsset.fetchAssets(with: .image, options: nil)
                                if let asset = assetResults.firstObject {
                                    let creationDate = asset.creationDate
                                    let location = asset.location
                                    if let image = tempImage {
                                        imagesWithMetadata.append((image, creationDate, location))
                                    }
                                }
                            }
                            group.leave()
                        }
                    } else {
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    self.parent.didFinishPicking?(imagesWithMetadata)
                }
            }
        }
    }
    
    var didFinishPicking: (([(UIImage, Date?, CLLocation?)]) -> Void)?
    var didCancel: (() -> Void)?
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
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
