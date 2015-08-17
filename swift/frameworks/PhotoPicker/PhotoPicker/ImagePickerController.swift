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

public class ImagePickerController: UINavigationController {

    init() {
        super.init(rootViewController: AlbumViewController())
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Bug: Swift 1.2 http://qiita.com/mzp/items/2243d7bf2ed98828fe38
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
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
}