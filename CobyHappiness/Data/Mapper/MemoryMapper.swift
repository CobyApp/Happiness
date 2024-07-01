//
//  MemoryMapper.swift
//  CobyHappiness
//
//  Created by Coby Kim on 6/26/24.
//

import UIKit

extension Memory {
    func toMemoryModel() -> MemoryModel {
        MemoryModel(
            id: self.id,
            date: self.date,
            type: self.type,
            title: self.title,
            note: self.note,
            location: self.location,
            photos: self.photos.compactMap { $0.image },
            bunches: self.bunches.map { $0.toBunchModel() }
        )
    }
}

extension MemoryModel {
    func toMemory() -> Memory {
        Memory(
            id: self.id,
            date: self.date,
            type: self.type,
            title: self.title,
            note: self.note,
            location: self.location,
            photos: self.photos.compactMap { self.compressImage($0) },
            bunches: self.bunches.map { $0.toBunch() }
        )
    }
    
    private func compressImage(_ image: UIImage) -> Data? {
        let newSize = CGSize(width: image.size.width * 0.3, height: image.size.height * 0.3)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let compressedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let compressedImageData = compressedImage?.jpegData(compressionQuality: 0.3) {
            return compressedImageData
        } else {
            return nil
        }
    }
}
