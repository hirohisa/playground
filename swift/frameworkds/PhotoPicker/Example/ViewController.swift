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

        let frame = CGRect(x: 200, y: 300, width: 80, height: 44)
        let button = UIButton(frame: frame)
        button.setTitle("開く", forState: .Normal)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.backgroundColor = UIColor.grayColor()
        button.addTarget(self, action: "showPhotoPicker", forControlEvents: .TouchUpInside)
        view.addSubview(button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func showPhotoPicker() {
        let picker = PhotoPicker()
        picker.showIn(viewController: self)
    }
}

