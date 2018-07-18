//
//  NSJAnimation+UIView.swift
//  NSJAnimations
//
//  Created by Chandrachudh on 11/06/18.
//  Copyright © 2018 NSJoker. All rights reserved.
//

import Foundation
import UIKit

fileprivate let FADE_ANIMATION_KEY = "kCATransitionFade"
fileprivate let SCALE_X_ANIMATION_KEY = "NSJscaleXYsXAnimation"
fileprivate let SCALE_Y_ANIMATION_KEY = "NSJscaleXYsYAnimation"

protocol ViewLayerAnimationDelegate: class {
    
}

typealias AnimationCompletionBlock = (Bool) -> Void

extension UIView {
    /**
     This will animate and fade the view, the view will not be removed from the screen.
     
     - Parameter duration: The duration for the animation.
     - Remark: The fade is temporary.
     - Precondition: This method call must be followed by some change in the view, else this will not be interesting!
     
     ### Usage Example: ###
     ````
     let animatingView = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
     animatingView.backgroundColor = .red
     view.addSubview(animatingView)
     animatingView.animateFade(duration: 1.0)
     animatingView.backgroundColor = .green
     */
    func animateFade(duration:TimeInterval) {
        self.layer.removeAnimation(forKey: FADE_ANIMATION_KEY)
        
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionFade
        animation.duration = duration
        self.layer.add(animation, forKey: FADE_ANIMATION_KEY)
    }
    
    /**
     This will animate and change the background color of the view.
     
     - Parameter toColor: The new background color for the view.
     - Parameter duration: The duration for the animation.
     - Remark: The background color change is permanent.
     
     ### Usage Example: ###
     ````
     let animatingView = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
     animatingView.backgroundColor = .red
     view.addSubview(animatingView)
     animatingView.animateAndChangeBackground(toColor: .green, duration: 1.0)
     */
    func animateAndChangeBackground(toColor:UIColor, duration:TimeInterval, options:UIViewAnimationOptions) {
        
        UIView.transition(with: self, duration: 1.0, options: .curveLinear, animations: {
            self.backgroundColor = toColor
        }) { (_) in
        }
    }
    
    /**
     This will animate and scale the view.
     
     - Parameter duration: The duration for the animation.
     - Parameter scaleBy: The value by which the view needs to be scaled.
     - Parameter shouldRevertBack:  set true to revert the effects of animation back to normal
     - Remark: The scale transformation is permanent.
     
     ### Usage Example: ###
     ````
     let animatingView = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
     animatingView.backgroundColor = .red
     view.addSubview(animatingView)
     animatingView.animateScaleduration: 2.0, scaleBy: 2.0, shouldRevertBack: false)
     */
    func animateScale(duration:TimeInterval, scaleBy:CGFloat, shouldRevertBack:Bool) {
        
        self.layer.removeAnimation(forKey: SCALE_X_ANIMATION_KEY)
        self.layer.removeAnimation(forKey: SCALE_Y_ANIMATION_KEY)
        
        let animationX = CABasicAnimation.init(keyPath: "transform.scale.x")
        animationX.toValue = scaleBy
        animationX.duration = duration
        animationX.isRemovedOnCompletion = shouldRevertBack
        animationX.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)
        animationX.fillMode = kCAFillModeForwards
        animationX.delegate = self
        animationX.autoreverses = shouldRevertBack
        self.layer.add(animationX, forKey: SCALE_X_ANIMATION_KEY)
        
        let animationY = CABasicAnimation.init(keyPath: "transform.scale.y")
        animationY.toValue = scaleBy
        animationY.duration = duration
        animationY.isRemovedOnCompletion = shouldRevertBack
        animationY.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)
        animationY.fillMode = kCAFillModeForwards
        animationY.delegate = self
        animationY.autoreverses = shouldRevertBack
        self.layer.add(animationY, forKey: SCALE_Y_ANIMATION_KEY)
    }
    
    /**
     This will animate and scale the view to the value provided and will also hide the view at the end of it .
     
     - Parameter duration: The duration for the animation.
     - Parameter scaleBy: The value by which the view needs to be scaled.
     - Parameter shouldRevertBack:  set true to revert the scale transform effects of animation back to normal
     - Remark: The scale transformation is permanent. You can unhide the view by setting its .isHidden to false.
     
     ### Usage Example: ###
     ````
     let animatingView = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
     animatingView.backgroundColor = .red
     view.addSubview(animatingView)
     animatingView.animateScaleAndHide(duration: 2.0, scaleBy: 2.0, shouldRevertBack: true)
     */
    func animateScaleAndHide(duration:TimeInterval, scaleBy:CGFloat, shouldRevertBack:Bool) {
        animateScale(duration: duration, scaleBy: scaleBy, shouldRevertBack: shouldRevertBack)
        
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        }) { (finished) in
            self.alpha = 1.0
            self.isHidden = true
        }
    }
    
    func animateCornerRadiusTo(radius:CGFloat, duration:TimeInterval) {
        basicLayerAnimationWith(keyPath: "cornerRadius", toValue: radius, duration: duration, shouldRemoveOnCompletion: false, fillMode: kCAFillModeBoth, repeatCount: 1, shouldAutoReverse: false, animationKey: "CornerRadiusAnimation")
    }
    
    
    func basicLayerAnimationWith(keyPath:String, toValue:Any, duration:TimeInterval, shouldRemoveOnCompletion:Bool = false, fillMode:String = kCAFillModeBoth, repeatCount:Float = 1.0, shouldAutoReverse:Bool, animationKey:String) {
        
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = shouldRemoveOnCompletion
        animation.fillMode = fillMode
        animation.autoreverses = shouldAutoReverse
        animation.repeatCount = repeatCount
        layer.add(animation, forKey: animationKey)
    }
}

extension UIView:CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if anim == layer.animation(forKey: "NSJscaleXYsXAnimation") {
            if anim.autoreverses == false {
                if let toValue = (anim as! CABasicAnimation).toValue {
                    self.transform = CGAffineTransform(scaleX: toValue as! CGFloat, y: toValue as! CGFloat)
                }
            }
        }
    }
}
