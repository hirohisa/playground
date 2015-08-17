//
//  ViewController.swift
//  Example
//
//  Created by Hirohisa Kawasaki on 4/7/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit
import PhotoPicker

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let delay = 0.5 * Double(NSEC_PER_SEC)
        let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            self.showPhotoPicker()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func showPhotoPicker() {
        let picker = PhotoPicker()
        picker.showIn(viewController: self)
    }
}

extension ViewController: ImagePickerControllerDelegate {

    func imagePickerController(picker: ImagePickerController, didFinishPickingAssets assets: [PHAsset]) {
        println(__FUNCTION__)
        println(assets)
    }

    func imagePickerControllerDidCancel(picker: ImagePickerController) {
        println(__FUNCTION__)
    }
}

