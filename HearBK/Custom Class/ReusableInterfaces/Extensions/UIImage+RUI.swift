//
//  UIImage+RUI.swift
//  Cozy Up
//
//  Created by Amisha on 15/10/18.
//  Copyright © 2018 Amisha. All rights reserved.
//

import UIKit


extension UIImage {
    
    func imageResize ()-> UIImage{
        
        let hasAlpha = true
        let scale: CGFloat = 1.0
        let sizeChange:CGSize = CGSize(width: self.size.width * self.scale, height: self.size.height * self.scale)
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
}
