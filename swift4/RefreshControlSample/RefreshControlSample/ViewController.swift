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

    var isAlphabet = false
    let alphabet = "abcdefghijklmnopqrstuvwxyz".map({$0})

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.refreshHeaderView.backgroundColor = UIColor.blue

        tableView.onRefresh = {
            print("refreshing")

            self.isAlphabet = !self.isAlphabet
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.tableView.stopAnimating()
                self.tableView.reloadData()
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
        let number = indexPath.row
        if isAlphabet {
            cell.textLabel?.text = String(alphabet[number])
        } else {
            cell.textLabel?.text = number.description
        }
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
}

