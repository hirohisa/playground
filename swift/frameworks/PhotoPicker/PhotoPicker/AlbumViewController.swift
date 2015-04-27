//
//  AlbumViewController.swift
//  PhotoPicker
//
//  Created by Hirohisa Kawasaki on 4/12/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit
import Photos

extension PhotoPicker {

    class AlbumViewController: UITableViewController {

        var collections: [PHAssetCollection] = [PHAssetCollection]() {
            didSet {
                tableView.reloadData()
            }
        }

        override func viewDidLoad() {
            super.viewDidLoad()

            configure()
        }
    }
}

extension PhotoPicker.AlbumViewController {

    func configure() {
        let leftBarButtonItem = UIBarButtonItem(title: "Close", style: .Plain, target: self, action: "dismiss")
        navigationItem.leftBarButtonItem = leftBarButtonItem

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func getCollectionList() {
        let result = PHCollectionList.fetchTopLevelUserCollectionsWithOptions(nil)

        var collections = [PHAssetCollection]()
        result.enumerateObjectsUsingBlock { obj, index, stop in
            if let collection = obj as? PHAssetCollection {
                collections.append(collection)
            }
            if stop.memory {
                self.collections = collections
            }
        }
    }

    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: {})
    }

}