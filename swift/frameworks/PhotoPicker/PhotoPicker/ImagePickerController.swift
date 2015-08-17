//
//  ImagePickerController.swift
//  PhotoPicker
//
//  Created by Hirohisa Kawasaki on 8/17/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit
import Photos

public protocol ImagePickerControllerDelegate: UINavigationControllerDelegate {
    func imagePickerController(picker: ImagePickerController, didFinishPickingAssets assets: [PHAsset])
    func imagePickerControllerDidCancel(picker: ImagePickerController)
}

public protocol ImagePickerControllerDataSource: class {
    // Album's configuration
    func heightForRowInAlbum(picker: ImagePickerController) -> CGFloat
    func imagePickerController(picker: ImagePickerController, configureCell cell: UITableViewCell, collection: PHAssetCollection)

    // Asset's configuration
    var assetNib: UINib { get } // UICollectionViewCell
    func collectionViewLayout(picker: ImagePickerController) -> UICollectionViewLayout
    func imagePickerController(picker: ImagePickerController, configureCell cell: UICollectionViewCell, asset: PHAsset)
}

public class ImagePickerController: UINavigationController {

    let viewController = AlbumViewController()
    init() {
        dataSource = viewController
        super.init(rootViewController: viewController)
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Bug: Swift 1.2 http://qiita.com/mzp/items/2243d7bf2ed98828fe38
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        dataSource = viewController
        super.init(nibName: nil, bundle: nil)
    }

    private weak var __delegate: ImagePickerControllerDelegate?

    public override var delegate: UINavigationControllerDelegate? {
        get {
            return __delegate
        }
        set {
            __delegate = newValue as? ImagePickerControllerDelegate
        }
    }
    public unowned(unsafe) var dataSource: ImagePickerControllerDataSource
}

extension AlbumViewController: ImagePickerControllerDataSource {

    func heightForRowInAlbum(picker: ImagePickerController) -> CGFloat {
        return 100
    }

    func imagePickerController(picker: ImagePickerController, configureCell cell: UITableViewCell, collection: PHAssetCollection) {
        cell.textLabel?.text = collection.localizedTitle
        cell.separatorInset = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 0)
        cell.accessoryType = .DisclosureIndicator
    }

    var assetNib: UINib {
        let bundle = NSBundle(forClass: AssetCell.self)
        return UINib(nibName: "AssetCell", bundle: bundle)
    }

    func collectionViewLayout(picker: ImagePickerController) -> UICollectionViewLayout {
        let collectionViewLayout = UICollectionViewFlowLayout()
        let margin: CGFloat = 10
        let length = (view.frame.width - margin * 4) / 3
        collectionViewLayout.itemSize = CGSize(width: length, height: length)
        collectionViewLayout.minimumInteritemSpacing = margin
        collectionViewLayout.minimumLineSpacing = margin
        return collectionViewLayout
    }

    func imagePickerController(picker: ImagePickerController, configureCell cell: UICollectionViewCell, asset: PHAsset) {
        let cell = cell as! AssetCell

        let options = PHImageRequestOptions()
        options.deliveryMode = .HighQualityFormat
        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .AspectFill, options: options) { image, info in
            cell.imageView.image = image
        }
    }

}