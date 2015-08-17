//
//  AssetsViewController.swift
//  PhotoPicker
//
//  Created by Hirohisa Kawasaki on 4/11/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit
import Photos

public class AssetsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var submitButton: UIButton!

    var assets: [PHAsset] = [] {
        didSet {
            if isViewLoaded() {
                collectionView.reloadData()
            }
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

    public override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    func configure() {
        let picker = navigationController as! ImagePickerController
        picker.dataSource.imagePickerController(picker, configureCollectionView: collectionView)

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

    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        let asset = assets[indexPath.item]
        let result = selectedAssets.filter{ $0 == asset }
        if result.isEmpty {
            selectedAssets.append(asset)
        } else {
            selectedAssets = selectedAssets.filter{ $0 != asset }
        }
        collectionView.reloadData()
    }

    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let asset = assets[indexPath.item]

        let picker = navigationController as! ImagePickerController
        let cell = picker.dataSource.imagePickerController(picker, collectionView: collectionView, cellForItemAtIndexPath: indexPath, asset: asset)
        cell.selected = !selectedAssets.filter{ $0 == asset }.isEmpty ? true:false

        return cell
    }

    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
}
