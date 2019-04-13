//
//  UIImage+RGB.swift
//  Pods
//
//  Created by DragonCherry on 6/30/16.
//
//

import UIKit

extension UIImage {
    
    public class func image(red: Int, green: Int, blue: Int, alpha: Float = 1) -> UIImage? {
        return UIImage.image(with: UIColor(alpha: alpha, red: red, green: green, blue: blue))
    }
    
    public class func image(with rgb: Int, alpha: Float = 1) -> UIImage? {
        return UIImage.image(with: UIColor(rgbHex: rgb, alpha: alpha))
    }
    
    public class func image(with rgb: Int, alpha: Float, size: CGSize) -> UIImage? {
        return UIImage.image(with: UIColor(rgbHex: rgb, alpha: alpha), size: size)
    }
    
    public class func image(with color: UIColor) -> UIImage? {
        return image(with: color, size: CGSize(width: 1, height: 1))
    }
    
    public class func image(with color: UIColor, size: CGSize) -> UIImage? {
        
        let area: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(area.size)
        
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(area)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
