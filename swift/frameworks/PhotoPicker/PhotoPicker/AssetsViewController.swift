//
//  AssetsViewController.swift
//  PhotoPicker
//
//  Created by Hirohisa Kawasaki on 4/11/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit
import Photos

class AssetsViewController: UICollectionViewController {

    init(collection: PHAssetCollection) {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        fetchAssets(collection)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var assets: [PHAsset] = [] {
        didSet {
            reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.whiteColor()
        let bundle = NSBundle(forClass: AssetCell.self)
        collectionView?.registerNib(UINib(nibName: "AssetCell", bundle: bundle), forCellWithReuseIdentifier: "cell")
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

    func reloadData() {
        collectionView?.reloadData()
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! AssetCell

        let asset = assets[indexPath.item]

        let options = PHImageRequestOptions()
        options.deliveryMode = .HighQualityFormat
        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .AspectFill, options: options) { image, info in
            cell.imageView.image = image
        }

        return cell
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
}
