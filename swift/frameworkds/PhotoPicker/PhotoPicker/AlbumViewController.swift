//
//  AlbumViewController.swift
//  PhotoPicker
//
//  Created by Hirohisa Kawasaki on 4/12/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

extension PhotoPicker {

    class AlbumViewController: UITableViewController {

        override func viewDidLoad() {
            super.viewDidLoad()

            let leftBarButtonItem = UIBarButtonItem(title: "Close", style: .Plain, target: self, action: "dismiss")
            navigationItem.leftBarButtonItem = leftBarButtonItem
        }
    }
}

extension PhotoPicker.AlbumViewController {

    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: {})
    }

}