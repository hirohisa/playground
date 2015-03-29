//
//  Layout.swift
//  GridView
//
//  Created by Hirohisa Kawasaki on 3/4/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

public protocol LayoutDataSource {
    func numberOfPartition() -> Int
    func scaleOfCollectionViewCellAtIndexPath(indexPath: NSIndexPath) -> Int
}

struct GridRect: Printable {
    var index: Int
    var x: CGFloat
    var y: CGFloat
    var length: CGFloat

    var description: String {
        return "GridRect: \(index), (\(x), \(y)), \(length))"
    }
}

class GridRects {

    var rects = [GridRect]()

    subscript (index: Int) -> GridRect? {
        for rect in rects {
            if rect.index == index {
                return rect
            }
        }
        return nil
    }

    func push(rect: GridRect) {
        rects.append(rect)
    }
}


public class Layout: UICollectionViewLayout {

    public override func prepareLayout() {
        reloadData()
    }

    public var dataSource: LayoutDataSource?

    let gridRects = GridRects()

    required public override init() {
        super.init()
        //minimumInteritemSpacing = 0
        //minimumLineSpacing = 0
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func collectionViewContentSize() -> CGSize {
        if let collectionView = collectionView {
            return collectionView.frame.size
        }
        return CGSizeZero
    }

    func numberOfItems() -> Int {
        if let collectionView = collectionView {
            return collectionView.numberOfItemsInSection(0)
        }

        return 0
    }

    func numberOfPartition() -> Int {
        if let dataSource = dataSource {
            return dataSource.numberOfPartition()
        }
        return 1
    }

    func lengthOfGrid() -> CGFloat {
        if let collectionView = collectionView {
            return CGRectGetWidth(collectionView.frame) / CGFloat(numberOfPartition())
        }

        return 0.0
    }

    func indexPathsForItemsInRect(rect: CGRect) -> [NSIndexPath] {
        var array = [NSIndexPath]()
        let min = 0
        let max = numberOfItems()

        for i in min...max-1 {
            let indexPath = NSIndexPath(forRow: i, inSection: 0)
            array.append(indexPath)
        }

        return array
    }

    public override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        let indexes = indexPathsForItemsInRect(rect)

        var attributes = [UICollectionViewLayoutAttributes]()

        for indexPath: NSIndexPath in indexes {
            let att = layoutAttributesForItemAtIndexPath(indexPath)
            attributes.append(att)
        }

        return attributes
    }

    public override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        let attributes = _layoutAttributesForItemAtIndexPath(indexPath)

        return attributes
    }

    func _layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes {
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        let index = indexPath.row

        //let size = sizeOfCellAtIndexPath(indexPath)

        if let rect = gridRects[index] {
            let frame = CGRect(x: rect.x, y: rect.y, width: rect.length, height: rect.length)
            attributes.frame = frame
        }

        return attributes
    }

}

class YAdjuster {

    var ys: [CGFloat] = [CGFloat]()

    init(count: Int) {
        var array = [CGFloat]()
        for i in 0..<count {
            array.append(CGFloat(0))
        }
        ys = array
    }

    subscript (index: Int) -> CGFloat {
        get {
            return ys[index]
        }
        set {
            ys[index] = newValue
        }
    }

    func indexOfLowest(start: Int, _ range: Int ) -> Int {
        var index = start
        for i in start...start+range {
            if ys[i] < ys[index] {
                index = i
            }
        }

        return index
    }
}

extension Layout {

    func reloadData() {
        _reloadGridRects()
    }

    func _reloadGridRects() {

        let adjuster = YAdjuster(count: numberOfPartition())

        for index in 0...numberOfItems() {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            let scale = self.dataSource!.scaleOfCollectionViewCellAtIndexPath(indexPath)

            // get y
            let lowest = adjuster.indexOfLowest(0, numberOfPartition()-scale)

            let length = lengthOfGrid() * CGFloat(scale)
            let x = lengthOfGrid() * CGFloat(lowest)
            var y = adjuster[lowest]

            // create rect
            let rect = GridRect(index: index, x: x, y: y, length: length)
            gridRects.push(rect)
            
            // set y
            for i in lowest..<lowest+scale {
                adjuster[i] = y + length
            }
        }
    }
}