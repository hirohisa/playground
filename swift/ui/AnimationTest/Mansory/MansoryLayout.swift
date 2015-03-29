//
//  MansoryLayout.swift
//  Mansory
//
//  Created by Hirohisa Kawasaki on 2015/02/06.
//  Copyright (c) 2015年 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

public class MansoryLayout: UICollectionViewFlowLayout {

    var column: Int = 5
    required public override init() {
        super.init()
        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 0
        println("call init")
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func collectionViewContentSize() -> CGSize {
        if let collectionView = self.collectionView {
            return collectionView.frame.size
        }
        return CGSizeZero
    }

    func numberOfItems() -> Int {
        if let collectionView = self.collectionView {
            return collectionView.numberOfItemsInSection(0)
        }

        return 0
    }

    func indexPathsForItemsInRect(rect: CGRect) -> [NSIndexPath] {
        var array = [NSIndexPath]()
        let min = 0
        let max = self.numberOfItems()
        for i in min...max-1 {
            let indexPath = NSIndexPath(forRow: i, inSection: 0)
            array.append(indexPath)
        }

        return array
    }

    public override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        let indexes = self.indexPathsForItemsInRect(rect)

        var attributes = [UICollectionViewLayoutAttributes]()

        for indexPath: NSIndexPath in indexes {
            let att = self.layoutAttributesForItemAtIndexPath(indexPath)
            attributes.append(att)
        }

        return attributes
    }

    public override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        //let attributes = self._layoutAttributesForItemAtIndexPath(indexPath) // default
        let attributes = self._layoutAttributesWithMovingSnakeForItemAtIndexPath(indexPath)

        return attributes
    }

    func _layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes {
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        let index = indexPath.row

        var length = 0
        if let collectionView = self.collectionView {
            length = Int(CGRectGetWidth(collectionView.frame) / CGFloat(column))
        }

        let x = Int(length * (index%column))
        let y = Int(length * Int(index/column))
        let frame = CGRect(x: x, y: y, width: length, height: length)
        attributes.frame = frame

        return attributes
    }

    func _layoutAttributesWithMovingSnakeForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes {
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        let index = indexPath.row

        let is_even = Int(index/column)%2 == 1

        var length = 0
        if let collectionView = self.collectionView {
            length = Int(CGRectGetWidth(collectionView.frame) / CGFloat(column))
        }

        var x = Int(length * (index%column))
        let y = Int(length * Int(index/column))
        if is_even {
            x = Int(length * (column - index%column - 1))
        }
        let frame = CGRect(x: x, y: y, width: length, height: length)
        attributes.frame = frame
        attributes.zIndex = 1

        return attributes
    }

    public override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath)
        if let attributes = attributes {
            //self._initialLayoutAttributesWithMovingFromBottom(attributes)
            //self._initialLayoutAttributesWithMovingSlide(attributes, itemIndexPath: itemIndexPath)
            self._initialLayoutAttributesWithMovingSnake(attributes, itemIndexPath: itemIndexPath)
        }

        return attributes
    }

    func _initialLayoutAttributesWithMovingSnake(attributes: UICollectionViewLayoutAttributes, itemIndexPath: NSIndexPath) {
        if let collectionView = self.collectionView {

            let is_even = Int(itemIndexPath.row/column)%2 == 1

            let index = itemIndexPath.row - 1
            let length = CGRectGetWidth(collectionView.frame) / CGFloat(column)
            var x = length * CGFloat(index%column)
            var y = length * CGFloat(index/column)

            if is_even && Int(index%column) != 4 {
                x = length * CGFloat(column - index%column - 1)
            } else if !is_even && Int(index%column) == 4 {
                x = 0
            }
            attributes.frame = CGRect(x: x, y: y, width: length, height: length)
            attributes.zIndex =  -index
            attributes.alpha = 1
        }
    }

    // slide animation
    func _initialLayoutAttributesWithMovingSlide(attributes: UICollectionViewLayoutAttributes, itemIndexPath: NSIndexPath) {
        if let collectionView = self.collectionView {
            let index = itemIndexPath.row - 1
            let length = CGRectGetWidth(collectionView.frame) / CGFloat(column)
            var x = length * CGFloat(index%column)
            var y = length * CGFloat(index/column)
            if index%column == 4 {
                x = -length
                y += length
            }
            attributes.frame = CGRect(x: x, y: y, width: length, height: length)
            attributes.zIndex =  -index
            attributes.alpha = 1
        }
    }

    // move from bottom animation
    func _initialLayoutAttributesWithMovingFromBottom(attributes: UICollectionViewLayoutAttributes) {
        if let collectionView = self.collectionView {
            attributes.frame = CGRect(x: 0, y: CGRectGetMaxY(collectionView.frame), width: 0, height: 0)
        }
    }

    public override func finalizeLayoutTransition() {
        println("finalizeLayoutTransition")
    }
}
