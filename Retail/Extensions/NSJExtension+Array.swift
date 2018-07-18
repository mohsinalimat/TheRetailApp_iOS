//
//  NSJExtension+Array.swift
//  Retail
//
//  Created by Chandrachudh on 17/07/18.
//  Copyright © 2018 Chandrachudh. All rights reserved.
//

import Foundation

extension Array {
    
    /// Random item from array.
    public var randomItem: Element? {
        if self.isEmpty { return nil }
        let index = Int(arc4random_uniform(UInt32(count)))
        return self[index]
    }
    
    /// Shuffled version of array.
    public var shuffled: [Element] {
        var arr = self
        for _ in 0..<10 {
            arr.sort { (_,_) in arc4random() < arc4random() }
        }
        return arr
    }
    
    /// Shuffle array.
    public mutating func shuffle() {
        // https://gist.github.com/ijoshsmith/5e3c7d8c2099a3fe8dc3
        for _ in 0..<10 {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
    
    /// Element at the given index if it exists.
    ///
    /// - Parameter index: index of element.
    /// - Returns: optional element (if exists).
    public func item(at index: Int) -> Element? {
        guard index >= 0 && index < count else { return nil }
        return self[index]
    }
}
