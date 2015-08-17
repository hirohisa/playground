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
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell

        let collection = collections[indexPath.row]
        cell.textLabel?.text = collection.localizedTitle

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let collection = collections[indexPath.row]

        let viewController = AssetsViewController(nibName: "AssetsViewController", bundle: NSBundle(forClass: AssetsViewController.self))
        viewController.collection = collection
        navigationController?.pushViewController(viewController, animated: true)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count
    }
}

extension AlbumViewController {

    func configure() {
        let leftBarButtonItem = UIBarButtonItem(title: "Close", style: .Plain, target: self, action: "dismiss")
        navigationItem.leftBarButtonItem = leftBarButtonItem

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
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