//
//  NSJExtension+UIViewController.swift
//  txt
//
//  Created by Chandrachudh on 28/06/18.
//  Copyright © 2018 F22labs. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlertWith(message:String, actions:[UIAlertAction]) {
        let alertController = UIAlertController(title: NSJApp.appName, message: message, preferredStyle: .alert)
        for alertAction in actions {
            alertController.addAction(alertAction)
        }
        present(alertController, animated: true, completion: nil)
    }
    
    func showSettingsAlertWith(alertMessage:String) {
        
        let alertController = UIAlertController.init(title: NSJApp.appName, message: alertMessage, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let settingsAction = UIAlertAction.init(title: "Settings", style: .default) { (action) in
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
        }
        alertController.addAction(settingsAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showTostWith(message:String) {
        
        let lblToast = UILabel(frame: CGRect(x: 0, y: 0, width: NSJDevice.screenWidth, height: NSJDevice.screenHeight))
        lblToast.text = message
        lblToast.textAlignment = .center
        lblToast.textColor = .white
        lblToast.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        lblToast.numberOfLines = 0
        lblToast.backgroundColor = UIColor.rgba(fromHex: 0x000000, alpha: 0.5)
        
        UIApplication.shared.keyWindow?.addSubview(lblToast)
        lblToast.alpha = 0.0
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
            lblToast.alpha = 1.0
        }) { (finshed) in
            UIView.animate(withDuration: 0.25, delay: 1.5, options: .curveEaseIn, animations: {
                lblToast.alpha = 0.0
            }, completion: { (finished) in
                lblToast.removeFromSuperview()
            })
        }        
    }
}
