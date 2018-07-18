//
//  NSJExtension+UIView.swift
//  NSJAnimations
//
//  Created by Chandrachudh on 19/06/18.
//  Copyright © 2018 NSJoker. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    /**
     Adds shadow to the primary layer of the view.
     
     - Parameter shadowPath: The shape of the layer’s shadow.
     - Parameter shadowColor: The color of the layer’s shadow.
     - Parameter shadowOpacity: The opacity of the layer’s shadow. The value in this property must be in the range 0.0 (transparent) to 1.0 (opaque).
     - Parameter shadowRadius: The blur radius (in points) used to render the layer’s shadow. You specify the radius.
     - Parameter shadowOffset: The offset (in points) of the layer’s shadow.
     - Remark: All the properties here are animatable.
     
     ### Usage Example: ###
     ````
     let shadowView = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
     shadowView.backgroundColor = .red
     view.addSubview(shadowView)
     
     let shadowPath = UIBezierPath(rect: shadowView.bounds).cgPath
     shadowView.addShadowWith(shadowPath: shadowPath, shadowColor: UIColor.black.cgColor, shadowOpacity: 0.4, shadowRadius: 5.0, shadowOffset: CGSize.zero)
     */
    
    func addShadowWith(shadowPath:CGPath, shadowColor:CGColor, shadowOpacity:Float, shadowRadius:CGFloat, shadowOffset:CGSize) {
        layer.masksToBounds = true
        layer.shadowColor = shadowColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = shadowOffset
        clipsToBounds = false
        layer.shadowPath = shadowPath
    }
    
    /**
     Brings all subviews in their respective order to the front.
     - Remark: Usaully used when you are adding a layer and want it behind all the subviews of the view.
     */
    func bringAllSubViewsToFront() {
        for subview in subviews {
            bringSubview(toFront: subview)
        }
    }
    
    /**
     Adds the user interation of the view and brings alpah to 1.0
     - Remark: If you have set the alpha of the object manually to a value less than 1.0 then after excecuting this method you have to set it again.
     */
    func enableUserInteraction() {
        alpha = 1.0
        isUserInteractionEnabled = true
    }
    
    /**
     Removes the user interation of the view and slighly reduces the alpha to 0.3 to indicate this
     */
    func disableUserInteraction() {
        alpha = 0.5
        isUserInteractionEnabled = false
    }
    
    /**
     Makes the corners rounded by setting the corner radius of its layer to half of the current height of the view
     - Ramerk: clipsToBounds value is set to true.
     */
    func makeRoundedByHeight() {
        clipsToBounds = true
        layer.cornerRadius = frame.height/2
    }
    
    /**
     Makes the corners rounded by setting the corner radius of its layer to half of the current width of the view
     - Ramerk: clipsToBounds value is set to true.
     */
    func makeRoundedByWidth() {
        clipsToBounds = true
        layer.cornerRadius = frame.width/2
    }
    
    /**
     Sets the corner radius to 0.0
     - Ramark: clipsToBounds value is unaltered.
     */
    func removeCornerRadius() {
        layer.cornerRadius = 0.0
    }
    
    func rotateBy(rotation: CGFloat) {
        transform = transform.rotated(by: rotation)
    }
    
    func addGradient(colors:[CGColor], frame:CGRect) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = colors
        gradient.frame = frame
        layer.insertSublayer(gradient, at: 0)
        return gradient
    }
}
