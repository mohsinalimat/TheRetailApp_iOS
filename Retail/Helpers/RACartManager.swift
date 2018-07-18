//
//  RACartManager.swift
//  Retail
//
//  Created by Chandrachudh on 16/07/18.
//  Copyright © 2018 Chandrachudh. All rights reserved.
//

import UIKit

//Since the inventory is very small, usng Coredata to store items in permanent memory if not optimistic. Hence using Userdefaults.

private let CART_KEY = "Items_Cart"

class RACartManager: NSObject {

    static let shared = RACartManager()
    var allItemsInCart:[String] {
        
        if let itemIds = UserDefaults.standard.value(forKey: CART_KEY) {
            return itemIds as! [String]
        }
        return [String]()
    }
    
    var hasItemsInCart:Bool {
        return (allItemsInCart.count != 0)
    }
    
    func isItemAlreadyInCart(item:RAItem)->Bool {
        guard let itemId = item.itemID else {
            return false
        }
        return allItemsInCart.contains(itemId)
    }
    
    func addItemToCart(item:RAItem) {
        guard let itemId = item.itemID else {
            return
        }
        var itemsArray = allItemsInCart
        itemsArray.append(itemId)
        UserDefaults.standard.set(itemsArray, forKey: CART_KEY)
    }
    
    func removeItemFromCart(item:RAItem) {
        guard let itemId = item.itemID else {
            return
        }
        var itemsArray = allItemsInCart
        if itemsArray.contains(itemId) {
            itemsArray.remove(at: itemsArray.index(of: itemId)!)
            UserDefaults.standard.set(itemsArray, forKey: CART_KEY)
        }
    }
    
    func removeAllItemsFromCart() {
        UserDefaults.standard.set([String](), forKey: CART_KEY)
    }
}
