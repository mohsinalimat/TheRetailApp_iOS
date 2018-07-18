//
//  AMHorizontalCarouselLayout.swift
//  Catalogue
//
//  Created by Chandrachudh on 02/02/18.
//  Copyright © 2018 F22Labs. All rights reserved.
//

import UIKit

protocol AMHorizontalCarouselLayoutDelegate:class {
    func getNumberOfSectionsAndRowsFor(collectionView:UICollectionView)->(sections:Int, rows:Int)
}

class AMHorizontalCarouselLayout: UICollectionViewFlowLayout {
    private let standardItemAlpha:CGFloat  = 0.4
    private let standardItemScale:CGFloat = 0.7
    
    weak var delegate:AMHorizontalCarouselLayoutDelegate?
    
    override func prepare() {
        super.prepare()
        collectionView?.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    private func getFocusCenter()->CGFloat {
        return 16 + (itemSize.width/2)
    }
    
    private func changeAttributes(attributes:UICollectionViewLayoutAttributes, scale:Bool, fade:Bool, zIndex:Bool) {
        let collectionCenter = getFocusCenter()
        let offset = collectionView?.contentOffset.x
        let normalizedcenter = attributes.center.x - offset!
        
        let maxDistance = self.itemSize.width + self.minimumInteritemSpacing
        let distance = min(abs(collectionCenter - normalizedcenter), maxDistance)
        
        let ratio = (maxDistance - distance)/maxDistance
        
        if fade {
            let alpha = ratio * (1-standardItemAlpha) + standardItemAlpha
            attributes.alpha = alpha
        }
        
        if scale {
            let scale = ratio * (1-standardItemScale) + standardItemScale
            attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        }
        
        if zIndex {
            let sectionInt = (delegate?.getNumberOfSectionsAndRowsFor(collectionView: collectionView!).sections)! - attributes.indexPath.section
            let rowInt = (delegate?.getNumberOfSectionsAndRowsFor(collectionView: collectionView!).rows)! - attributes.indexPath.row
            attributes.zIndex = sectionInt * rowInt
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else {
            return [UICollectionViewLayoutAttributes]()
        }
        
        var attributesCopy = [UICollectionViewLayoutAttributes]()
        let center:CGFloat = (itemSize.width/2) + (collectionView?.contentOffset.x)!
        let sortedLayoutAttributes = attributes.sorted { abs($0.center.x - center) < abs($1.center.x - center)}
        
        guard let closest = sortedLayoutAttributes.first else {
            return attributesCopy
        }
        
        let closestIndexPath = closest.indexPath
        for itemAttributes in attributes {
            let itemAttributesCopy = itemAttributes.copy() as! UICollectionViewLayoutAttributes
            if itemAttributesCopy.indexPath.row < closestIndexPath.row {
                itemAttributesCopy.center = CGPoint(x: -100, y: itemAttributesCopy.center.y)
                itemAttributesCopy.transform3D = CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 1)
                itemAttributesCopy.alpha = 1.0
            }
            else if itemAttributesCopy.indexPath.row == closestIndexPath.row {
                changeAttributes(attributes: itemAttributesCopy, scale: false, fade: true, zIndex: true)
            }
            else {
                changeAttributes(attributes: itemAttributesCopy, scale: true, fade: false, zIndex: true)
                itemAttributesCopy.alpha = 1.0
            }
            attributesCopy.append(itemAttributesCopy)
        }
        
        return attributesCopy
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        let layoutAttributes = self.layoutAttributesForElements(in: (collectionView?.bounds)!)
        
        let center = getFocusCenter()
        let proposedContentOffsetCenterOrigin = proposedContentOffset.x + center
        
        let sortedLayoutAttributes = layoutAttributes?.sorted { abs($0.center.x - proposedContentOffsetCenterOrigin) < abs($1.center.x - proposedContentOffsetCenterOrigin)}
        let closest = sortedLayoutAttributes?.first ?? UICollectionViewLayoutAttributes()
        
        let targetContentOffset = CGPoint(x: floor(closest.center.x - center), y: proposedContentOffset.y)
        
        return targetContentOffset
    }
}
