//
//  RAHomeController.swift
//  Retail
//
//  Created by Chandrachudh on 16/07/18.
//  Copyright © 2018 Chandrachudh. All rights reserved.
//

import UIKit

class RAHomeController: UIViewController {
    
    @IBOutlet weak var btnUserLogin: UIButton!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var furnituresCollectionView: UICollectionView!
    @IBOutlet weak var electronicsCollectionView: UICollectionView!
    @IBOutlet weak var lblFurnitures: UILabel!
    @IBOutlet weak var lblElectronics: UILabel!
    
    let electronics = RAItem.getElectronics()
    let furnitures = RAItem.getFurnitures()
    let lblBadge = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblFurnitures.text = "Furnitures (\(furnitures.count))"
        lblElectronics.text = "Electronics (\(electronics.count))"
        setupCollectionViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Target Methods
    @IBAction func showLoggedingUser(_ sender: Any) {
        //If the user is loggedin then show the user profile, else prompt the user to login
        if RALoginManager.shared.isUserLoggedIn {
            let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let logoutAlertAction = UIAlertAction(title: "Logout", style: .destructive) { (action) in
                RALoginManager.shared.loggoutuser()
                self.prepareView()
            }
            showAlertWith(message: "Would you like to logout?", actions: [cancelAlertAction, logoutAlertAction])
        }
        else {
            present(RALandingController(), animated: YES, completion: nil)
        }
    }
    
    @IBAction func showCart() {
        let cartPage = RACartController()
        let cartNavigationController = UINavigationController(rootViewController: cartPage)
        cartNavigationController.isNavigationBarHidden = true
        present(cartNavigationController, animated: true, completion: nil)
    }
    
    //MARK: - Helper Methods
    private func prepareView() {
        btnUserLogin.setImage(#imageLiteral(resourceName: "User_Icon"), for: .normal)
        if RALoginManager.shared.isUserLoggedIn {
            btnUserLogin.setImage(#imageLiteral(resourceName: "JhonDoe"), for: .normal)
        }
        
        lblBadge.isHidden = true
        if RACartManager.shared.hasItemsInCart {
            lblBadge.isHidden = false
            lblBadge.text = "\(RACartManager.shared.allItemsInCart.count)"
            lblBadge.textColor = .white
            lblBadge.textAlignment = .center
            lblBadge.font = UIFont.systemFont(ofSize: 12)
            lblBadge.backgroundColor = .red
            lblBadge.sizeToFit()
            
            lblBadge.frame = CGRect(x: NSJDevice.screenWidth - 40, y: 5, width: max(lblBadge.frame.width + 5, lblBadge.frame.height+2), height: lblBadge.frame.height+2)
            lblBadge.makeRoundedByHeight()
            
            if lblBadge.superview == nil {
                btnCart.superview?.addSubview(lblBadge)
            }
        }
    }
    
    private func setupCollectionViews() {
        
        electronicsCollectionView.registerNibWithReuseidentifier(resueidentifier: RAItemCell.reuseIdentifier)
        furnituresCollectionView.registerNibWithReuseidentifier(resueidentifier: RAItemCell.reuseIdentifier)
        
        electronicsCollectionView.setCollectionViewLayout(getCustomFlowLayout(), animated: false)
        furnituresCollectionView.setCollectionViewLayout(getCustomFlowLayout(), animated: false)
        
        electronicsCollectionView.dataSource = self
        electronicsCollectionView.delegate = self
        furnituresCollectionView.dataSource = self
        furnituresCollectionView.delegate = self
        
        electronicsCollectionView.reloadData()
        furnituresCollectionView.reloadData()
    }
    
    private func getCustomFlowLayout()->AMHorizontalCarouselLayout {
        let flowLayout = AMHorizontalCarouselLayout()
        flowLayout.itemSize = RAHomeController.getItemSize()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = -70
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 16, 0, flowLayout.itemSize.width)
        flowLayout.delegate = self
        return flowLayout
    }
    
    class func getItemSize()->CGSize {
        var itemSize = CGSize(width: 166, height: 244)
        if NSJDevice.currentDeviceType == .iPhoneX || NSJDevice.currentDeviceType == .iPhone8Plus {
            return itemSize
        }
        
        //made up ratio!
        let baseItemWidth:CGFloat = 166
        let baseItemHeight:CGFloat = 244
        let baseScreenHeight:CGFloat = 812
        let baseScreenWidth:CGFloat = 375
        
        itemSize = CGSize(width: baseItemWidth * NSJDevice.screenWidth / baseScreenWidth, height: baseItemHeight * NSJDevice.screenHeight / baseScreenHeight)
        
        return itemSize
    }
    
    fileprivate func scrollCollectionViewToItemAtIndexPath(indexPath:IndexPath, collectionView:UICollectionView) {
        var proposedOffest = CGPoint.zero
        proposedOffest.x = CGFloat(indexPath.row) * ((collectionView.collectionViewLayout as! AMHorizontalCarouselLayout).itemSize.width + (collectionView.collectionViewLayout as! AMHorizontalCarouselLayout).minimumLineSpacing)
        let newContentOffest = (collectionView.collectionViewLayout as! AMHorizontalCarouselLayout).targetContentOffset(forProposedContentOffset: proposedOffest, withScrollingVelocity: CGPoint.zero)
        collectionView.setContentOffset(newContentOffest, animated: true)
    }
    
    fileprivate func getItemArrayFor(collectionView:UICollectionView)->[RAItem] {
        return (collectionView == furnituresCollectionView) ? furnitures : electronics
    }
}

extension RAHomeController: AMHorizontalCarouselLayoutDelegate {
    func getNumberOfSectionsAndRowsFor(collectionView:UICollectionView)->(sections:Int, rows:Int) {
        return (collectionView == furnituresCollectionView) ? (1, furnitures.count) : (1, electronics.count)
    }
}

extension RAHomeController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getItemArrayFor(collectionView: collectionView).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemsArray = getItemArrayFor(collectionView: collectionView)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RAItemCell.reuseIdentifier, for: indexPath) as! RAItemCell
        cell.myCollectionView = collectionView
        cell.prepareCellWith(item: itemsArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        scrollCollectionViewToItemAtIndexPath(indexPath: indexPath, collectionView: collectionView)
        
        let detailsView = Bundle.main.loadNibNamed("RAItemDetailsView", owner: self, options: nil)![0] as! RAItemDetailsView
        detailsView.frame = CGRect(x: 0, y: 0, width: NSJDevice.screenWidth, height: NSJDevice.screenHeight)
        UIApplication.shared.keyWindow?.addSubview(detailsView)
        detailsView.selectedItem = getItemArrayFor(collectionView: collectionView)[indexPath.row]
        detailsView.animateAndShow()
        detailsView.delegate = self
    }
}

extension RAHomeController: RAItemDetailsViewDelegate {
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
}

extension RAHomeController: RALandingControllerDelegate {
    func showCartPage() {
        perform(#selector(showCart), with: nil, afterDelay: 1.0)
    }
}
