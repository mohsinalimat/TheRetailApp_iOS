//
//  NSJExtension+NSNumber.swift
//  Retail
//
//  Created by Chandrachudh on 18/07/18.
//  Copyright © 2018 Chandrachudh. All rights reserved.
//

import Foundation


extension NSNumber {
    func getPriceString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "en_IN")
        
        var priceStr = numberFormatter.string(from: self)
        if (priceStr?.hasSuffix(".00"))! {
            priceStr = (priceStr! as NSString).replacingOccurrences(of: ".00", with: "")
        }
        return priceStr ?? String(self.intValue)
    }
}
