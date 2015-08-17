//
//  AssetsViewController.swift
//  PhotoPicker
//
//  Created by Hirohisa Kawasaki on 4/11/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit
import Photos

class AssetsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var submitButton: UIButton!

    var assets: [PHAsset] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    var collection: PHAssetCollection? {
        didSet {
            if let collection = collection {
                fetchAssets(collection)
            }
        }
    }

    var selectedAssets: [PHAsset] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    func configure() {
        collectionView.backgroundColor = UIColor.whiteColor()

        let picker = navigationController as! ImagePickerController
        collectionView.collectionViewLayout = picker.dataSource.collectionViewLayout(picker)
        collectionView.registerNib(picker.dataSource.assetNib, forCellWithReuseIdentifier: "cell")

        submitButton.addTarget(self, action: "submit", forControlEvents: .TouchUpInside)
    }

    func fetchAssets(collection: PHAssetCollection) {
        let result = PHAsset.fetchAssetsInAssetCollection(collection, options: nil)

        var assets = [PHAsset]()

        result.enumerateObjectsUsingBlock { obj, _, _ in
            if let asset = obj as? PHAsset {
                assets.append(asset)
            }
        }
        self.assets = assets
    }

    func submit() {
        if let navigationController = navigationController as? ImagePickerController, let delegate = navigationController.delegate as? ImagePickerControllerDelegate {
            delegate.imagePickerController(navigationController, didFinishPickingAssets: selectedAssets)
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
}

extension AssetsViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        let asset = assets[indexPath.item]
        let result = selectedAssets.filter{ $0 == asset }
        if result.isEmpty {
            selectedAssets.append(asset)
        } else {
            selectedAssets = selectedAssets.filter{ $0 != asset }
        }
        collectionView.reloadData()
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! AssetCell
        let asset = assets[indexPath.item]


        let picker = navigationController as! ImagePickerController
        picker.dataSource.imagePickerController(picker, configureCell: cell, asset: asset)

        cell.selected = !selectedAssets.filter{ $0 == asset }.isEmpty ? true:false

        return cell
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
}
