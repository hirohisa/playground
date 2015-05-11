//
//  MessageBar.swift
//  KeyboardSample
//
//  Created by Hirohisa Kawasaki on 5/12/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

class MessageBar: UIToolbar {

    let textView = UITextView(frame: CGRectZero)
    let sendButton = UIButton.buttonWithType(.System) as! UIButton

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    func configure() {

        textView.backgroundColor = UIColor(white: 250/255, alpha: 1)
        textView.font = UIFont.systemFontOfSize(messageFontSize)
        textView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha:1).CGColor
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 5
        textView.scrollsToTop = false
        textView.textContainerInset = UIEdgeInsetsMake(4, 3, 3, 3)
        addSubview(textView)

        sendButton.enabled = false
        sendButton.titleLabel?.font = UIFont.boldSystemFontOfSize(17)
        sendButton.setTitle("Send", forState: .Normal)
        sendButton.setTitleColor(UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1), forState: .Disabled)
        sendButton.setTitleColor(UIColor(red: 1/255, green: 122/255, blue: 255/255, alpha: 1), forState: .Normal)
        sendButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        addSubview(sendButton)

        // Auto Layout allows `sendButton` to change width, e.g., for localization.
        textView.setTranslatesAutoresizingMaskIntoConstraints(false)
        sendButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        addConstraint(NSLayoutConstraint(item: textView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint(item: textView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 7.5))
        addConstraint(NSLayoutConstraint(item: textView, attribute: .Right, relatedBy: .Equal, toItem: sendButton, attribute: .Left, multiplier: 1, constant: -2))
        addConstraint(NSLayoutConstraint(item: textView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: -8))
        addConstraint(NSLayoutConstraint(item: sendButton, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: sendButton, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: -4.5))
    }

}
