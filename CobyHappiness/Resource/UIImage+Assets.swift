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
    static let icPerson = UIImage(name: "person")!
    static let icSetting = UIImage(name: "setting")!
    static let icTravel = UIImage(name: "travel")!
    static let icTrip = UIImage(name: "trip")!
    static let icFood = UIImage(name: "food")!
    static let icHobby = UIImage(name: "favorite")!
    static let icMoment = UIImage(name: "flag")!
}

extension UIImage {
    var compressedImage: Data {
        self.jpegData(compressionQuality: 0.3)!
    }
}
