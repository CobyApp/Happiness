//
//  UIImage+Assets.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 2023/09/21.
//

import UIKit

extension UIImage {
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
