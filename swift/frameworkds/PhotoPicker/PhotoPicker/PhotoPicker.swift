//
//  PhotoPicker.swift
//  PhotoPicker
//
//  Created by Hirohisa Kawasaki on 4/11/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import Foundation

public class PhotoPicker {

    let viewController = CollectionViewController()
    public init() {
    }

    public func showIn(#source: UIViewController) {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let takeAPictureAction = UIAlertAction(title: "写真を撮る", style: .Default) { _ in
        }
        controller.addAction(takeAPictureAction)
        let cameraRollAction = UIAlertAction(title: "カメラロールを開く", style: .Default) { _ in
        }
        controller.addAction(cameraRollAction)
        let cancelAction = UIAlertAction(title: "キャンセル", style: .Cancel) { _ in
        }
        controller.addAction(cancelAction)

        source.presentViewController(controller, animated: true) { _ in }
    }
}
