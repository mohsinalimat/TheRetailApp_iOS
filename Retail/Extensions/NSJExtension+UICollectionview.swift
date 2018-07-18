//
//  NSJExtension+UICollectionview.swift
//  txt
//
//  Created by Chandrachudh on 21/06/18.
//  Copyright © 2018 F22labs. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    func registerNibWithReuseidentifier(resueidentifier:String) {
        let nib = UINib(nibName: resueidentifier, bundle: nil)
        register(nib, forCellWithReuseIdentifier: resueidentifier)
    }
    
    func registerNibsWithReuseIdentifiers(reuseidentifiers:[String]) {
        for reuseidentifier in reuseidentifiers {
            registerNibWithReuseidentifier(resueidentifier: reuseidentifier)
        }
    }
    
    func reloadItemsWithAnimation(items:[IndexPath]) {
        performBatchUpdates(
            {
                self.reloadItems(at: items)
        }, completion: { (finished:Bool) -> Void in
        })
    }
}
