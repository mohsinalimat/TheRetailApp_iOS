//
//  GradientView.swift
//  aimee
//
//  Created by Chandrachudh on 16/07/18.
//  Copyright © 2018 Chandrachudh. All rights reserved.
//

import Foundation
import UIKit

/**
 The IBDesignable class that you can use in IB to create a gradient layer
 */
@IBDesignable class GradientView: UIView {
    
    @IBInspectable var topColor: UIColor = UIColor.rgba(fromHex: 0x74DFE1, alpha: 1.0)
    @IBInspectable var midColor: UIColor?
    @IBInspectable var bottomColor: UIColor = UIColor.rgba(fromHex: 0x39B1B6, alpha: 1.0)
    @IBInspectable var startPoint: CGPoint = CGPoint(x: 0.5, y: 0)
    @IBInspectable var endPoint: CGPoint = CGPoint(x: 0.5, y: 1)
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        var gradientColors = [topColor.cgColor, bottomColor.cgColor]
        var gradientLocations = [NSNumber.init(value: 0.10), NSNumber.init(value: 1.0)]
        if let midColor = midColor {
            gradientColors.insert(midColor.cgColor, at: 1)
            gradientLocations = [NSNumber.init(value: 0.0), NSNumber.init(value: 0.4), NSNumber.init(value: 0.6)]
        }
        (layer as! CAGradientLayer).colors = gradientColors
        (layer as! CAGradientLayer).locations = gradientLocations
        (layer as! CAGradientLayer).startPoint = startPoint
        (layer as! CAGradientLayer).endPoint = endPoint
    }
}
