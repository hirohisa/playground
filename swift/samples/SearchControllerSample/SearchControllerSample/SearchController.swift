//
//  SearchController.swift
//  SearchControllerSample
//
//  Created by Hirohisa Kawasaki on 5/13/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

class SearchResultController: UITableViewController {

    var source = [String]()
    var result = split("D,E,F,L,M,N", isSeparator: { $0 == "," })

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        cell.textLabel?.text = result[indexPath.row]

        return cell
    }

    func reloadData() {
        tableView.reloadData()
    }

}

class SearchController: UITableViewController, UISearchBarDelegate {

    var result: [String] = split("A,B,C,D,E,F,G,H,I,J,K,L,M,N", isSeparator: { $0 == "," })
    var searchController: UISearchController!
    let resultController = SearchResultController()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")

        resultController.source = result

        searchController = UISearchController(searchResultsController: resultController)

        let frame = navigationController!.navigationBar.frame
        searchController.searchBar.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.titleView = searchController.searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        cell.textLabel?.text = result[indexPath.row]
        
        return cell
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        resultController.reloadData()
    }
}
