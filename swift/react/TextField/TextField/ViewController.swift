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

    var textFieldSignal: ReactKit.Signal<NSString?>?
    let textField: UITextField = {
        let textField = UITextField(frame: CGRectZero)
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        textField.frame = CGRect(x: 10, y: 100, width: view.frame.width - 20, height: 60)
        textField.borderStyle = .Line
        textFieldSignal = textField.textChangedSignal()

        ^{ println($0) } <~ textFieldSignal!

        view.addSubview(textField)
    }

}

