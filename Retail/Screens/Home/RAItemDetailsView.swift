//
//  RAItemDetailsView.swift
//  Retail
//
//  Created by Chandrachudh on 18/07/18.
//  Copyright © 2018 Chandrachudh. All rights reserved.
//

import UIKit

protocol RAItemDetailsViewDelegate:class {
    func cartUpdated(didAdd:Bool)
    func askForConfirmationToDelete(item:RAItem)
}

class RAItemDetailsView: UIView {
    
    weak var delegate:RAItemDetailsViewDelegate?

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var lcContentViewBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var imgItem: UIImageView!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblItemPrice: UILabel!
    @IBOutlet weak var btnCart: UIButton!
    
    let dismissControl = UIControl()
    var selectedItem:RAItem?
    
    private func prepareView() {
        addSubview(dismissControl)
        dismissControl.addTarget(self, action: #selector(animateAndHide), for: .touchUpInside)
        bringSubview(toFront: contentView)
        addMaskingLayerToContentView()
        
        btnCart.makeRoundedByHeight()
        btnCart.layer.borderColor = UIColor.blue.cgColor
        btnCart.layer.borderWidth = 1.0
        btnCart.setTitleColor(UIColor.blue, for: .normal)
        btnCart.setTitle("Add To Cart", for: .normal)
        
        guard let selectedItem = selectedItem else {
            lblItemName.text = "NA"
            lblItemPrice.text = "NA"
            btnCart.disableUserInteraction()
            return
        }
        
        imgItem.image = selectedItem.itemImages[0]
        lblItemPrice.text = selectedItem.itemPrice?.getPriceString()
        lblItemName.text = selectedItem.itemName
        
        if RACartManager.shared.isItemAlreadyInCart(item: selectedItem) {
            btnCart.setTitle("Remove From Cart", for: .normal)
            btnCart.layer.borderColor = UIColor.red.cgColor
            btnCart.setTitleColor(UIColor.red, for: .normal)
        }
    }
    
    func addMaskingLayerToContentView() {
        
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: NSJDevice.screenWidth, height: NSJDevice.screenHeight), byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 15.0, height: 15.0)).cgPath
        let maskLayer = CAShapeLayer()
        maskLayer.path = path
        contentView.layer.mask = maskLayer
    }
    
    func animateAndShow() {
        prepareView()
        lcContentViewBottomSpace.constant = -NSJDevice.screenHeight
        layoutIfNeeded()
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            self.lcContentViewBottomSpace.constant = 0
            self.layoutIfNeeded()
        }) { (finished) in
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dismissControl.frame = bounds
    }
    
    //MARK: - Target Methods
    @objc func animateAndHide() {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            self.lcContentViewBottomSpace.constant = -NSJDevice.screenHeight
            self.layoutIfNeeded()
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
    @IBAction func didTapCartButton(_ sender: Any) {
        guard let selectedItem = selectedItem else {
            return
        }
        if RACartManager.shared.isItemAlreadyInCart(item: selectedItem) {
            delegate?.askForConfirmationToDelete(item: selectedItem)
        }
        else {
            RACartManager.shared.addItemToCart(item: selectedItem)
            delegate?.cartUpdated(didAdd: true)
        }
        
        animateAndHide()
    }
}
