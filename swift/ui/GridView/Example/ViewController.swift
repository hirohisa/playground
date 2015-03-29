//
//  ViewController.swift
//  Example
//
//  Created by Hirohisa Kawasaki on 3/4/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit
import GridView

class ViewController: UICollectionViewController {

    var count = 50

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = GridView.Layout()
        layout.dataSource = self
        collectionView?.collectionViewLayout = layout
        collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension ViewController: UICollectionViewDelegate {

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.reloadData()
    }
}

extension ViewController: UICollectionViewDataSource {

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as UICollectionViewCell

        switch indexPath.row%9 {
        case 0:
            cell.backgroundColor = UIColor.blueColor()
        case 1:
            cell.backgroundColor = UIColor.orangeColor()
        case 2:
            cell.backgroundColor = UIColor.redColor()
        case 3:
            cell.backgroundColor = UIColor.greenColor()
        case 4:
            cell.backgroundColor = UIColor.brownColor()
        case 5:
            cell.backgroundColor = UIColor.purpleColor()
        case 6:
            cell.backgroundColor = UIColor.yellowColor()
        case 7:
            cell.backgroundColor = UIColor.magentaColor()
        default:
            cell.backgroundColor = UIColor.grayColor()
        }

        return cell
    }
}

extension ViewController: GridView.LayoutDataSource {
    func numberOfPartition() -> Int {
        return 5
    }

    func scaleOfCollectionViewCellAtIndexPath(indexPath: NSIndexPath) -> Int {

        var length = 1

        switch indexPath.row {
        case 2, 12, 22:
            length = 2
        default:
            break
        }

        return length
    }
}