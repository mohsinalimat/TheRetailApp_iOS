//
//  NSJSwiftFunctions.swift
//  NSJAnimations
//
//  Created by Chandrachudh on 19/06/18.
//  Copyright © 2018 NSJoker. All rights reserved.
//

import Foundation
import UIKit

public enum DeviceType {
    case iPhone5s
    case iPhone8
    case iPhone8Plus
    case iPhoneX
}

let YES = true
let NO = false

enum HudPosition {
    case top,bottom
}

enum HudBgColor {
    case red,blue,gray
}

public struct NSJDevice {
    public static var screenOrientation: UIInterfaceOrientation {
        return UIApplication.shared.statusBarOrientation
    }
    
    public static var screenWidth:CGFloat {
        if UIInterfaceOrientationIsPortrait(screenOrientation) {
            return UIScreen.main.bounds.width
        }
        else {
            return UIScreen.main.bounds.height
        }
    }
    
    public static var screenHeight:CGFloat {
        if UIInterfaceOrientationIsPortrait(screenOrientation) {
            return UIScreen.main.bounds.height
        }
        else {
            return UIScreen.main.bounds.width
        }
    }
    
    public static var isSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
    
    public static var currentDeviceType:DeviceType {
        var deviceType = DeviceType.iPhone8Plus
        
        if NSJDevice.screenHeight < 600 {
            deviceType = .iPhone5s
        }
        else if NSJDevice.screenHeight < 670 {
            deviceType = .iPhone8
        }
        else if NSJDevice.screenHeight > 800 {
            deviceType = .iPhoneX
        }
        
        return deviceType
    }
    
    public static var currentRegion: String? {
        return (Locale.current as NSLocale).object(forKey: NSLocale.Key.countryCode) as? String
    }
    
    public static var screenStatusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    
    public static func makeStatusBarDark() {
        DispatchQueue.main.async {
            UIApplication.shared.statusBarStyle = .default
        }
    }
    
    public static func makeStatusBarLight() {
        DispatchQueue.main.async {
            UIApplication.shared.statusBarStyle = .lightContent
        }
    }
}

public struct NSJApp {
    public static var appName:String? {
        if let bundleDisplayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
            return bundleDisplayName
        }
        else if let bundleName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            return bundleName
        }
        return nil
    }
    
    public static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
    public static var appBuildNumber: String? {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
    }
}
