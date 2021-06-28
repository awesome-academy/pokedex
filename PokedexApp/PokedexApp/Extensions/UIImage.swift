//
//  UIImage.swift
//  PokedexApp
//
//  Created by Phong Le on 25/06/2021.
//

import UIKit

extension UIImage {
    func resizeTabBarItem() -> UIImage {
        let hasAlpha = true
        let scale = 0.0
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 16.0, height: 16.0), !hasAlpha, CGFloat(scale))
        self.draw(in: CGRect(origin: .zero, size: CGSize(width: 16.0, height: 16.0)))
        
        guard let scaledImage = UIGraphicsGetImageFromCurrentImageContext() else { fatalError() }
        return scaledImage
    }
}
