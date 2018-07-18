//
//  RALoginManager.swift
//  Retail
//
//  Created by Chandrachudh on 16/07/18.
//  Copyright © 2018 Chandrachudh. All rights reserved.
//

import UIKit

class RALoginManager: NSObject {
    private let kAuthKey = "IS_LOGGED_IN"

    static let shared = RALoginManager()
    
    var isUserLoggedIn:Bool {
        if UserDefaults.standard.object(forKey: kAuthKey) != nil {
            return true
        }
        return false
    }
    
    func userLoggedIn() {
        UserDefaults.standard.set("YES", forKey: kAuthKey)
    }
    
    func loggoutuser() {
        UserDefaults.standard.removeObject(forKey: kAuthKey)
    }
    
}
