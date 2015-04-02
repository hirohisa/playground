//
//  ViewController.swift
//  TextField
//
//  Created by Hirohisa Kawasaki on 4/2/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit
import ReactKit

class ViewController: UIViewController {

    let textField: UITextField = {
        let textField = UITextField(frame: CGRectZero)
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        textField.frame = CGRect(x: 10, y: 100, width: view.frame.width - 20, height: 60)
        textField.borderStyle = .Line
        textField.textChangedSignal().ownedBy(self).react{ string in
            println(string)
        }
        view.addSubview(textField)
    }

}

