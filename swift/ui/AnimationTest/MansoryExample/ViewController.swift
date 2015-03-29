//
//  ViewController.swift
//  MansoryExample
//
//  Created by Hirohisa Kawasaki on 2015/02/05.
//  Copyright (c) 2015年 Hirohisa Kawasaki. All rights reserved.
//

import UIKit
import Mansory

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var mansory: Mansory?
    var list: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        list = [1]
        self.view.backgroundColor = UIColor.whiteColor()

        let layout = MansoryLayout()
        println(layout)

        mansory = Mansory(frame: self.view.bounds, collectionViewLayout: layout)
        mansory?.alwaysBounceVertical = true
        mansory?.dataSource = self
        mansory?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.view.addSubview(mansory!)

        println(mansory)

        let delay = 0.1 * Double(NSEC_PER_SEC)
        let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            self.after()
        })
        println("finish viewDidLoad")
    }

    func after() {
        if list.count > 45 {
            print("finish animation")
            return
        }

        let indexPaths = [
            NSIndexPath(forRow: list.count, inSection: 0)
        ]

        for indexPath: NSIndexPath in indexPaths {
            self.list.append(1)
        }

        mansory?.performBatchUpdates({
            self.mansory!.insertItemsAtIndexPaths(indexPaths)
            }, completion:{ _ in
                let delay = 0.01 * Double(NSEC_PER_SEC)
                let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue(), {
                    self.after()
                })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension ViewController: UICollectionViewDelegate {
}

extension ViewController: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return list.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as UICollectionViewCell

        switch indexPath.row%4 {
        case 0:
            cell.backgroundColor = UIColor.blueColor()
        case 1:
            cell.backgroundColor = UIColor.orangeColor()
        case 2:
            cell.backgroundColor = UIColor.purpleColor()
        default:
            cell.backgroundColor = UIColor.grayColor()
        }

        return cell
    }

}

