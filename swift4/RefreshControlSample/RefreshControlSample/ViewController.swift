//
//  ViewController.swift
//  RefreshControlSample
//
//  Created by Hirohisa Kawasaki on 2018/07/02.
//  Copyright © 2018 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

class ViewController: PullToRefreshViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: RefreshableTableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.refreshHeaderView.backgroundColor = UIColor.blue

        tableView.onRefresh = {
            print("refreshing")

            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.tableView.stopAnimating()
            })
        }

        tableView.onLoadMore = {
            print("loading more")
            self.tableView.stopAnimating()
        }

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = indexPath.description
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
}

