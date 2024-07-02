//
//  UIImage+Assets.swift
//  CobyHappiness
//
//  Created by Coby on 6/12/24.
//

import UIKit

extension UIImage {
    
    convenience init?(name: String) {
        self.init(named: name, in: .main, compatibleWith: nil)
    }
    
    static let icLogo = UIImage(name: "logo")!
    
    // Icon
    static let icFilter = UIImage(name: "filter")!
    static let icHome = UIImage(name: "home")!
    static let icMap = UIImage(name: "map")!
    static let icMore = UIImage(name: "more")!
    static let icPerson = UIImage(name: "person")!
    static let icPlus = UIImage(name: "plus")!
    static let icSetting = UIImage(name: "setting")!
    static let icTravel = UIImage(name: "travel")!
}

extension UIImage {
    var compressedImage: Data {
        let newSize = CGSize(width: self.size.width * 0.3, height: self.size.height * 0.3)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let compressedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return (compressedImage?.jpegData(compressionQuality: 0.3))!
    }
}
