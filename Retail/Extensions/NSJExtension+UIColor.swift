//
//  UIColorExtension.swift
//  NSJAnimations
//
//  Created by Chandrachudh on 11/06/18.
//  Copyright © 2018 NSJoker. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    /**
     Create a UIColor object by passing hex values
     
     - Parameter fromHex: The hex value for the color in the format 0xFFFFFF
     - Returns: A UIColor object
     
     ### Usage Example: ###
     ````
     let colorView = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
     colorView.backgroundColor = UIColor.rgb(fromHex: 0xFF0000)
     view.addSubview(colorView)
     */
    class func rgb(fromHex: Int) -> UIColor {
        let alpha = CGFloat(1.0)
        return UIColor.rgba(fromHex: fromHex, alpha: alpha)
    }
    
    /**
     Create a UIColor object with altered alpha by passing hex values
     
     - Parameter fromHex: The hex value for the color in the format 0xFFFFFF
     - Parameter alpha: The alpha value for the color
     - Returns: A UIColor object
     
     ### Usage Example: ###
     ````
     let colorView = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
     colorView.backgroundColor = UIColor.rgba(fromHex: 0xFF0000, alpha:0.5)
     view.addSubview(colorView)
     */
    class func rgba(fromHex: Int, alpha: CGFloat) -> UIColor {
        let red =   CGFloat((fromHex & 0xFF0000) >> 16) / 0xFF
        let green = CGFloat((fromHex & 0x00FF00) >> 8) / 0xFF
        let blue =  CGFloat(fromHex & 0x0000FF) / 0xFF
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    class var dialogueBGColor: UIColor {
        return UIColor.rgba(fromHex: 0x000000, alpha: 0.3)
    }
}
