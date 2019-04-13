//
//  UIColor+HF.swift
//  Pods
//
//  Created by DragonCherry on 6/30/16.
//
//

import UIKit

extension UIColor {
    
    open var RGBString: String {
        let colorRef = cgColor.components
        let r: CGFloat = colorRef![0]
        let g: CGFloat = colorRef![1]
        let b: CGFloat = colorRef![2]
        return String(NSString(format: "%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255))))
    }
    
    open var ARGBString: String {
        let colorRef = cgColor.components
        let a: CGFloat = cgColor.alpha
        let r: CGFloat = colorRef![0]
        let g: CGFloat = colorRef![1]
        let b: CGFloat = colorRef![2]
        return String(NSString(format: "%02lX%02lX%02lX%02lX", lroundf(Float(a * 255)), lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255))))
    }
    
    public convenience init(alpha: Float, red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        assert(alpha >= 0 || alpha <= 1, "Invalid alpha component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha))
    }
    
    public convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    public convenience init(rgbHex: Int) {
        self.init(
            red: (rgbHex >> 16) & 0xff,
            green: (rgbHex >> 8) & 0xff,
            blue: rgbHex & 0xff)
    }
    
    public convenience init(rgbHex: Int, alpha: Float) {
        self.init(
            red: CGFloat((rgbHex >> 16) & 0xff),
            green: CGFloat((rgbHex >> 8) & 0xff),
            blue: CGFloat(rgbHex & 0xff),
            alpha: CGFloat(alpha) / 255.0)
    }
    
    public convenience init(argbHex: UInt32) {
        let alpha: UInt32 = (argbHex >> 24)
        self.init(
            red: CGFloat((argbHex >> 16) & 0xff),
            green: CGFloat((argbHex >> 8) & 0xff),
            blue: CGFloat(argbHex & 0xff),
            alpha: CGFloat(alpha) / 255.0)
    }
}
