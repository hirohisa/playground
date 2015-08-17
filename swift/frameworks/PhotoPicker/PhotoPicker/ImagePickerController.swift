//
//  ImagePickerController.swift
//  PhotoPicker
//
//  Created by Hirohisa Kawasaki on 8/17/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit
import Photos

public let reuseIdentifier = "reuseIdentifier"

public protocol ImagePickerControllerDelegate: UINavigationControllerDelegate {
    func imagePickerController(picker: ImagePickerController, didFinishPickingAssets assets: [PHAsset])
    func imagePickerControllerDidCancel(picker: ImagePickerController)
}

public protocol ImagePickerControllerDataSource: class {
    // Album's configuration
    func heightForRowInAlbum(picker: ImagePickerController) -> CGFloat
    func imagePickerController(picker: ImagePickerController, configureCell cell: UITableViewCell, collection: PHAssetCollection)

    // Asset's configuration
    func createAssetsViewController() -> AssetsViewController
    func imagePickerController(picker: ImagePickerController, configureCollectionView collectionView: UICollectionView)
    func imagePickerController(picker: ImagePickerController, collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath, asset: PHAsset) -> UICollectionViewCell
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

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
    }
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

    func createAssetsViewController() -> AssetsViewController {
        return AssetsViewController(nibName: "AssetsViewController", bundle: NSBundle(forClass: AssetsViewController.self))
    }

    func imagePickerController(picker: ImagePickerController, configureCollectionView collectionView: UICollectionView) {
        collectionView.registerNib(UINib(nibName: "AssetCell", bundle: NSBundle(forClass: AssetCell.self)), forCellWithReuseIdentifier: reuseIdentifier)

        let collectionViewLayout = UICollectionViewFlowLayout()
        let margin: CGFloat = 10
        let length = (view.frame.width - margin * 4) / 3
        collectionViewLayout.itemSize = CGSize(width: length, height: length)
        collectionViewLayout.minimumInteritemSpacing = margin
        collectionViewLayout.minimumLineSpacing = margin
        collectionView.collectionViewLayout = collectionViewLayout
    }

    func imagePickerController(picker: ImagePickerController, collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath, asset: PHAsset) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! AssetCell

        let options = PHImageRequestOptions()
        options.deliveryMode = .HighQualityFormat
        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .AspectFill, options: options) { image, info in
            cell.imageView.image = image
        }

        return cell
    }

}