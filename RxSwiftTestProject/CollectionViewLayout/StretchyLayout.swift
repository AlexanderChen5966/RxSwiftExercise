//
//  StretchyLayout.swift
//  RxSwiftTestProject
//
//  Created by AlexanderChen on 2021/1/12.
//  Copyright © 2021 AlexanderChen. All rights reserved.
//

import Foundation
import UIKit

class StretchyLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // 1
        guard let collectionView = self.collectionView else { return nil }
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        // 2
        let insets = collectionView.contentInset
        let offset = collectionView.contentOffset
        let minY = -insets.top
        
        // 3
        if offset.y < minY {
            // 4
            let headerSize = self.headerReferenceSize
            let deltalY = abs(offset.y - minY)
            for attibute in attributes {
                // 5
                if attibute.representedElementKind == UICollectionView.elementKindSectionHeader {
                    // 6
                    var headerRect = attibute.frame
                    headerRect.size.height = headerSize.height + deltalY
                    headerRect.origin.y = headerRect.origin.y - deltalY
                    attibute.frame = headerRect
                }
            }
        }
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

}
