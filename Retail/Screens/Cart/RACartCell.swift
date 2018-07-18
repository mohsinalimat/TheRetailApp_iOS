//
//  RACartCell.swift
//  Retail
//
//  Created by Chandrachudh on 18/07/18.
//  Copyright © 2018 Chandrachudh. All rights reserved.
//

import UIKit

protocol RACartCellDelegate: class {
    func removeItemWithId(itemId:String)
}

class RACartCell: UICollectionViewCell {
    
    weak var delegate : RACartCellDelegate?

    static let reuseidentifier = "RACartCell"
    
    @IBOutlet weak var imgItem: UIImageView!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblItemCategory: UILabel!
    @IBOutlet weak var lblItemPrice: UILabel!
    @IBOutlet weak var lblSerialNumber: UILabel!
    @IBOutlet weak var btnRemove: UIButton!
    
    var currentItemID:String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func prepareCellWith(item:RAItem) {
        currentItemID = item.itemID
        imgItem.image = item.itemImages[0]
        lblItemName.text = item.itemName
        lblItemCategory.text = item.itemCategory?.getName()
        lblItemPrice.text = item.itemPrice?.getPriceString()
        
        btnRemove.makeRoundedByHeight()
    }
    
    @IBAction func didtapbuttonRemove(_ sender: Any) {
        delegate?.removeItemWithId(itemId: currentItemID!)
    }
}
