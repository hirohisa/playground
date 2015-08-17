//
//  AlbumViewController.swift
//  PhotoPicker
//
//  Created by Hirohisa Kawasaki on 4/12/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit
import Photos

class AlbumViewController: UITableViewController {

    var collections: [PHAssetCollection] = [PHAssetCollection]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        fetchCollections()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UITableViewCell

        let collection = collections[indexPath.row]

        let picker = navigationController as! ImagePickerController
        picker.dataSource.imagePickerController(picker, configureCell: cell, collection: collection)

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let collection = collections[indexPath.row]

        let picker = navigationController as! ImagePickerController
        let viewController = picker.dataSource.createAssetsViewController()
        viewController.collection = collection
        navigationController?.pushViewController(viewController, animated: true)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let picker = navigationController as! ImagePickerController
        return picker.dataSource.heightForRowInAlbum(picker)
    }

}

extension AlbumViewController {

    func configure() {
        let leftBarButtonItem = UIBarButtonItem(title: "Close", style: .Plain, target: self, action: "dismiss")
        navigationItem.leftBarButtonItem = leftBarButtonItem

        tableView.estimatedRowHeight = 60

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()

        view.backgroundColor = navigationController?.view.backgroundColor
    }

    func fetchCollections() {
        let result = PHCollectionList.fetchTopLevelUserCollectionsWithOptions(nil)

        var collections = [PHAssetCollection]()

        result.enumerateObjectsUsingBlock { obj, _, _ in
            if let collection = obj as? PHAssetCollection {
                collections.append(collection)
            }
        }
        self.collections = collections
    }

    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: {})
    }

}