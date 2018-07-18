//
//  RACartController.swift
//  Retail
//
//  Created by Chandrachudh on 18/07/18.
//  Copyright © 2018 Chandrachudh. All rights reserved.
//

import UIKit

class RACartController: UIViewController {

    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var cartCollection: UICollectionView!
    @IBOutlet weak var btnCheckOut: UIButton!
    @IBOutlet weak var lcTotalLableBaseHeight: NSLayoutConstraint!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblGST: UILabel!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var lblGrandTotal: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnClose.setImage(#imageLiteral(resourceName: "Close_Icon").withRenderingMode(.alwaysTemplate), for: .normal)
        btnClose.imageView?.tintColor = UIColor.rgb(fromHex: 0x434343)
        
        cartCollection.registerNibWithReuseidentifier(resueidentifier: RAEmptyCartCell.reuseidentifier)
        cartCollection.registerNibWithReuseidentifier(resueidentifier: RACartCell.reuseidentifier)
        
        cartCollection.delegate = self
        cartCollection.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: NSJDevice.screenWidth - 30, height: 100)
        layout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0)
        layout.minimumLineSpacing = 10.0
        layout.minimumInteritemSpacing = 10.0
        cartCollection.setCollectionViewLayout(layout, animated: false)
        
        prepareView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //Mark - Helper methods
    func prepareView() {
        
        cartCollection.reloadData()
        
        if RACartManager.shared.hasItemsInCart {
            btnCheckOut.enableUserInteraction()
            lcTotalLableBaseHeight.constant = 100.0
        }
        else {
            btnCheckOut.disableUserInteraction()
            lcTotalLableBaseHeight.constant = 0.0
        }
        view.layoutIfNeeded()
        
        
        var total:Float = 0.0
        for itemId in RACartManager.shared.allItemsInCart {
            let item = RAItem.getItemWith(itemID: itemId)
            total += (item?.itemPrice?.floatValue ?? 0.0)
        }
        lblTotal.animateFade(duration: 0.25)
        lblTotal.attributedText = getAttributtedStringFrom(title: "Total: ", value: total, font1: lblTotal.font.withSize(14), font2: lblTotal.font.withSize(16))
        
        let gst = total * 18/100
        lblGST.animateFade(duration: 0.25)
        lblGST.attributedText = getAttributtedStringFrom(title: "GST: ", value: gst, font1: lblGST.font.withSize(14), font2: lblGST.font.withSize(16))
        
        let grandTotal = total + gst
        lblGrandTotal.animateFade(duration: 0.25)
        lblGrandTotal.attributedText = getAttributtedStringFrom(title: "Grand Total: ", value: grandTotal, font1: lblGrandTotal.font.withSize(14), font2: lblGrandTotal.font.withSize(18))
        
    }
    
    func getAttributtedStringFrom(title:String, value:Float, font1:UIFont, font2:UIFont) -> NSMutableAttributedString {
        
        let titleString = title
        let valueString = NSNumber(value: value).getPriceString()
        let finalTotalString = titleString + valueString
        
        let titleRange = (finalTotalString as NSString).range(of: titleString)
        let valueRange = (finalTotalString as NSString).range(of: valueString)
        
        let totalAttrstr = NSMutableAttributedString(string: finalTotalString)
        totalAttrstr.addAttribute(NSAttributedStringKey.font, value: font1, range: titleRange)
        totalAttrstr.addAttribute(NSAttributedStringKey.font, value: font2, range: valueRange)
        
        return totalAttrstr
    }
    
    @objc func markOrderPlaced() {
        showTostWith(message: "Order Placed!")
        perform(#selector(showHomePage), with: nil, afterDelay: 2.0)
    }
    
    @objc func showHomePage() {
        RACartManager.shared.removeAllItemsFromCart()
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Target Methods
    @IBAction func didTapButtonClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapCheckoutButton(_ sender: Any) {
        showTostWith(message: "Please wait, placing your Order")
        perform(#selector(markOrderPlaced), with: nil, afterDelay: 2.0)
    }
}

extension RACartController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (RACartManager.shared.hasItemsInCart) ? RACartManager.shared.allItemsInCart.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if RACartManager.shared.hasItemsInCart {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RACartCell.reuseidentifier, for: indexPath) as! RACartCell
            
            let itemId = RACartManager.shared.allItemsInCart[indexPath.row]
            let item = RAItem.getItemWith(itemID: itemId)
            cell.prepareCellWith(item: item!)
            cell.delegate = self
            cell.lblSerialNumber.text = "\(indexPath.row+1)"
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RAEmptyCartCell.reuseidentifier, for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if RACartManager.shared.hasItemsInCart {
            let detailsView = Bundle.main.loadNibNamed("RAItemDetailsView", owner: self, options: nil)![0] as! RAItemDetailsView
            detailsView.frame = CGRect(x: 0, y: 0, width: NSJDevice.screenWidth, height: NSJDevice.screenHeight)
            UIApplication.shared.keyWindow?.addSubview(detailsView)
            detailsView.selectedItem = RAItem.getItemWith(itemID: RACartManager.shared.allItemsInCart[indexPath.row])
            detailsView.animateAndShow()
            detailsView.delegate = self
        }
    }
}

extension RACartController: RAItemDetailsViewDelegate, RACartCellDelegate {
    func cartUpdated(didAdd: Bool) {
        prepareView()
        
        if didAdd {
            showTostWith(message: "Item added to your cart")
        }
        else {
            showTostWith(message: "Item removed from your cart")
        }
    }
    
    func askForConfirmationToDelete(item: RAItem) {
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let removeAction = UIAlertAction(title: "Remove", style: .destructive) { (action) in
            RACartManager.shared.removeItemFromCart(item: item)
            self.cartUpdated(didAdd: false)
        }
        showAlertWith(message: "Are you sure that you want to remove this item from your cart?", actions: [cancelAction, removeAction])
    }
    
    func removeItemWithId(itemId: String) {
        let item = RAItem.getItemWith(itemID: itemId)
        askForConfirmationToDelete(item: item!)
    }
}
