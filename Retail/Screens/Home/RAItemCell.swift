//
//  RAItemCell.swift
//  Retail
//
//  Created by Chandrachudh on 17/07/18.
//  Copyright © 2018 Chandrachudh. All rights reserved.
//

import UIKit

class RAItemCell: UICollectionViewCell {
    
    static let reuseIdentifier = "RAItemCell"

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var imgItem: UIImageView!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lcimageWidth: NSLayoutConstraint!
    
    weak var myCollectionView:UICollectionView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func prepareCellWith(item:RAItem) {
        baseView.layer.cornerRadius = 10.0
        baseView.clipsToBounds = true
        baseView.layer.borderColor = UIColor.black.cgColor
        baseView.layer.borderWidth = 2.0
        addShadow()
        
        imgItem.image = item.itemImages[0]
        lblItemName.text = item.itemName
        
        lcimageWidth.constant = RAHomeController.getItemSize().width-20
        layoutIfNeeded()
    }
    
    private func addShadow() {
        let height = (myCollectionView?.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.height
        let width = (myCollectionView?.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width
        
        addShadowWith(shadowPath: UIBezierPath.init(rect: CGRect(x: 0, y: 0, width: width, height: height)).cgPath, shadowColor: UIColor.black.cgColor, shadowOpacity: 0.2, shadowRadius: 50.0, shadowOffset: CGSize(width: 0, height: 0))
    }
}
