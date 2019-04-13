//
//  UIImage+Alpha.swift
//  Pods
//
//  Created by DragonCherry on 8/2/16.
//
//

import UIKit

extension UIImage {
    
    open func applying(alpha: CGFloat) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        
        if let context = UIGraphicsGetCurrentContext(), let CGImage = self.cgImage {
            let area = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
            
            context.scaleBy(x: 1, y: -1)
            context.translateBy(x: 0, y: -area.size.height)
            context.setBlendMode(CGBlendMode.multiply)
            context.setAlpha(alpha)
            context.draw(CGImage, in: area)
            
            return UIGraphicsGetImageFromCurrentImageContext() ?? self
        }
        UIGraphicsEndImageContext()
        return self
    }
}
