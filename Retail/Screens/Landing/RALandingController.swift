//
//  RALandingController.swift
//  Retail
//
//  Created by Chandrachudh on 16/07/18.
//  Copyright © 2018 Chandrachudh. All rights reserved.
//

import UIKit

protocol RALandingControllerDelegate:class {
    func showCartPage()
}

class RALandingController: UIViewController {
    
    weak var delegate:RALandingControllerDelegate?

    @IBOutlet weak var btnInfo: UIButton!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnEmail: UIButton!
    
    var shoudlShowCartAfterAuth = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareButtonWith(button: btnFacebook, image: #imageLiteral(resourceName: "Facebook_Icon"))
        prepareButtonWith(button: btnEmail, image: #imageLiteral(resourceName: "Email_Icon"))
        perform(#selector(animateInfoButton), with: nil, afterDelay: 2.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Target Methods
    @IBAction func didTapInfoButton(_ sender: Any) {
        
        let message = "This model screen provides the feel of the Landing page.\nTap any button to see the main page of the app"
        let cancelAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        showAlertWith(message: message, actions: [cancelAlertAction])
    }
    
    private func prepareButtonWith(button:UIButton, image:UIImage) {
        button.imageView?.image = image.withRenderingMode(.alwaysTemplate)
        button.imageView?.tintColor = .white
        button.makeRoundedByHeight()
        button.addShadowWith(shadowPath: UIBezierPath(roundedRect: button.bounds, cornerRadius: button.bounds.height/2).cgPath, shadowColor: UIColor.black.cgColor, shadowOpacity: 0.7, shadowRadius: 4.0, shadowOffset: CGSize(width: 2, height: 4))
    }
    
    @objc private func animateInfoButton() {
        btnInfo.animateScale(duration:1.0, scaleBy: 1.2, shouldRevertBack: YES)
    }
    
    @IBAction func connectuser(_ sender: Any) {
        RALoginManager.shared.userLoggedIn()
        (sender as! UIButton).imageView?.tintColor = .white
        let cancelAlertAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
            DispatchQueue.main.async {
                self.closePage()
            }
        }
        showAlertWith(message: "User authenticated successfully", actions: [cancelAlertAction])
    }
    
    @IBAction func closePage() {
        if shoudlShowCartAfterAuth {
            delegate?.showCartPage()
        }
        self.dismiss(animated: YES, completion: nil)
    }
    
}
