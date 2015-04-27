//
//  ViewController.swift
//  ObjectMapperSample
//
//  Created by Hirohisa Kawasaki on 4/28/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        JsonReader.task("JSON/octocat").resume { result in
            println(result)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

