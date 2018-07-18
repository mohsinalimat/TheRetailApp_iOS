//
//  Items.swift
//  Retail
//
//  Created by Chandrachudh on 17/07/18.
//  Copyright © 2018 Chandrachudh. All rights reserved.
//

import Foundation
import UIKit

enum RACategory {
    case furniture
    case electronics
    
    func getName()->String {
        switch self {
        case .furniture:
            return "Furniture"
        default:
            return "Electronics"
        }
    }
}

private let microWave:RAItem = {
    let item = RAItem()
    item.itemImages = [#imageLiteral(resourceName: "microwave")]//[#imageLiteral(resourceName: "Micro_Wave1"),#imageLiteral(resourceName: "Micro_Wave2"),#imageLiteral(resourceName: "Micro_Wave3"),#imageLiteral(resourceName: "Micro_Wave4"),#imageLiteral(resourceName: "Micro_Wave5"),#imageLiteral(resourceName: "Micro_Wave6"),#imageLiteral(resourceName: "Micro_Wave7")]
    item.itemName = "Microwave Oven"
    item.itemPrice = NSNumber(value: 9999)
    item.itemCategory = .electronics
    item.itemID = "E1"
    return item
}()

private let television:RAItem = {
    let item = RAItem()
    item.itemImages = [#imageLiteral(resourceName: "television")]//[#imageLiteral(resourceName: "Television1"),#imageLiteral(resourceName: "Television2"),#imageLiteral(resourceName: "Television3"),#imageLiteral(resourceName: "Television4"),#imageLiteral(resourceName: "Television5"),#imageLiteral(resourceName: "Television6"),#imageLiteral(resourceName: "Television7"),#imageLiteral(resourceName: "Television8")]
    item.itemName = "Television"
    item.itemPrice = NSNumber(value: 13999)
    item.itemCategory = .electronics
    item.itemID = "E2"
    return item
}()

private let vacuumCleaner:RAItem = {
    let item = RAItem()
    item.itemImages = [#imageLiteral(resourceName: "vacuumcleaner")]//[#imageLiteral(resourceName: "Vacuum_Cleaner1"),#imageLiteral(resourceName: "Vacuum_Cleaner2"),#imageLiteral(resourceName: "Vacuum_Cleaner3"),#imageLiteral(resourceName: "Vacuum_Cleaner4"),#imageLiteral(resourceName: "Vacuum_Cleaner5"),#imageLiteral(resourceName: "Vacuum_Cleaner6"),#imageLiteral(resourceName: "Vacuum_Cleaner7")]
    item.itemName = "Vacuum Cleaner"
    item.itemPrice = NSNumber(value: 2860)
    item.itemCategory = .electronics
    item.itemID = "E3"
    return item
}()

private let table:RAItem = {
    let item = RAItem()
    item.itemImages = [#imageLiteral(resourceName: "table")]//[#imageLiteral(resourceName: "Table1"),#imageLiteral(resourceName: "Table2"),#imageLiteral(resourceName: "Table3"),#imageLiteral(resourceName: "Table4"),#imageLiteral(resourceName: "Table5")]
    item.itemName = "Table"
    item.itemPrice = NSNumber(value: 1444)
    item.itemCategory = .furniture
    item.itemID = "F1"
    return item
}()

private let chair:RAItem = {
    let item = RAItem()
    item.itemImages = [#imageLiteral(resourceName: "Chair")]//[#imageLiteral(resourceName: "Chair1"),#imageLiteral(resourceName: "Chair1.5"),#imageLiteral(resourceName: "Chair2"),#imageLiteral(resourceName: "Chair3"),#imageLiteral(resourceName: "Chair4"),#imageLiteral(resourceName: "Chair5"),#imageLiteral(resourceName: "Chair6")]
    item.itemName = "Chair"
    item.itemPrice = NSNumber(value: 7990)
    item.itemCategory = .furniture
    item.itemID = "F2"
    return item
}()

private let wardrobe:RAItem = {
    let item = RAItem()
    item.itemImages = [#imageLiteral(resourceName: "wardrobe")]//[#imageLiteral(resourceName: "Wardrobe1"),#imageLiteral(resourceName: "Wardrobe2"),#imageLiteral(resourceName: "Wardrobe3"),#imageLiteral(resourceName: "Wardrobe4"),#imageLiteral(resourceName: "Wardrobe5"),#imageLiteral(resourceName: "Wardrobe6"),#imageLiteral(resourceName: "Wardrobe7")]
    item.itemName = "Wardrobe"
    item.itemPrice = NSNumber(value: 9999)
    item.itemCategory = .furniture
    item.itemID = "F3"
    return item
}()

class RAItem:NSObject {
    var itemImages = [UIImage]()
    var itemName:String?
    var itemPrice:NSNumber?
    var itemCategory:RACategory?
    var itemID:String?
    
    class func getElectronics()->[RAItem] {
        return [microWave,television,vacuumCleaner].shuffled
    }
    
    class func getFurnitures()->[RAItem] {
        return [table,chair,wardrobe].shuffled
    }
    
    class func getItemWith(itemID:String)->RAItem? {
        var allItems = getElectronics()
        allItems.append(contentsOf: getFurnitures())
        
        for item in allItems {
            if item.itemID == itemID {
                return item
            }
        }
        
        return nil
    }
}
