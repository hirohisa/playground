//
//  ViewController.swift
//  KeyboardSample
//
//  Created by Hirohisa Kawasaki on 5/7/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var texts = [String]()
    let textView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")

        let frame = CGRect(x: 0, y: view.frame.height - 44 - 44, width: view.frame.width, height: 44)
        textView.frame = frame
        textView.backgroundColor = UIColor.lightGrayColor()

        tableView.addSubview(textView)

        let delay = 1.0 * Double(NSEC_PER_SEC)
        let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            self.show()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(animated: Bool) {
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

    func show() {
        textView.becomeFirstResponder()
        //let viewController = InputViewController()
        //navigationController?.pushViewController(viewController, animated: true)
    }

}

