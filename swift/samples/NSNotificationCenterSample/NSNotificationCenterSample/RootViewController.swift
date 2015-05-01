//
//  ViewController.swift
//  NSNotificationCenterSample
//
//  Created by Hirohisa Kawasaki on 5/2/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

class RootViewController: UITableViewController {

    class Page {
        typealias CreateClojure = () -> UIViewController?

        let title: String
        let create: CreateClojure

        init(title _title: String, create _create: CreateClojure) {
            title = _title
            create = _create
        }
    }

    var pages = [Page]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")

        pages = createPages()
    }

    func createPages() -> [Page] {

        var pages = [Page]()
        pages.append(Page(title: "keyboard") { KeyboardController() } )

        return pages
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pages.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        let page = pages[indexPath.row]

        cell.textLabel?.text = page.title

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let page = pages[indexPath.row]

        if let viewController = page.create() {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

