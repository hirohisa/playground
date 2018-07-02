//
//  ViewController.swift
//  RefreshControlSample
//
//  Created by Hirohisa Kawasaki on 2018/07/02.
//  Copyright © 2018 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
    }

    @objc func refresh(sender: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            sender.endRefreshing()
        })
    }
}

