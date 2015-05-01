//
//  KeyboardController.swift
//  NSNotificationCenterSample
//
//  Created by Hirohisa Kawasaki on 5/2/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

class KeyboardController: UITableViewController {

    var texts = [String]()
    let textView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")

        let frame = CGRect(x: 0, y: view.frame.height - 44 - 44, width: view.frame.width, height: 44)
        textView.frame = frame
        textView.backgroundColor = UIColor.lightGrayColor()

        view.addSubview(textView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(animated: Bool) {
        textView.becomeFirstResponder()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return texts.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell

        let text = texts[indexPath.row]
        cell.textLabel?.text = text

        return cell
    }
}
