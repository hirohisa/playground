//
//  ViewController.swift
//  KeyboardSample
//
//  Created by Hirohisa Kawasaki on 5/7/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

class Message {
    let incoming: Bool
    let text: String
    let sentDate: NSDate

    init(incoming: Bool, text: String, sentDate: NSDate) {
        self.incoming = incoming
        self.text = text
        self.sentDate = sentDate
    }
}

let messageFontSize: CGFloat = 17
let toolBarMinHeight: CGFloat = 44
let textViewMaxHeight: (portrait: CGFloat, landscape: CGFloat) = (portrait: 272, landscape: 90)

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    var tableView: UITableView!
    var toolBar: UIToolbar!
    var textView: UITextView!
    var sendButton: UIButton!
    var rotating = false
    var messages: [[Message]] = []

    override var inputAccessoryView: UIView! {
        get {
            if toolBar == nil {
                toolBar = UIToolbar(frame: CGRectMake(0, 0, 0, toolBarMinHeight-0.5))

                textView = InputTextView(frame: CGRectZero)
                textView.backgroundColor = UIColor(white: 250/255, alpha: 1)
                textView.delegate = self
                textView.font = UIFont.systemFontOfSize(messageFontSize)
                textView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha:1).CGColor
                textView.layer.borderWidth = 0.5
                textView.layer.cornerRadius = 5
                //        textView.placeholder = "Message"
                textView.scrollsToTop = false
                textView.textContainerInset = UIEdgeInsetsMake(4, 3, 3, 3)
                toolBar.addSubview(textView)

                sendButton = UIButton.buttonWithType(.System) as! UIButton
                sendButton.enabled = false
                sendButton.titleLabel?.font = UIFont.boldSystemFontOfSize(17)
                sendButton.setTitle("Send", forState: .Normal)
                sendButton.setTitleColor(UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1), forState: .Disabled)
                sendButton.setTitleColor(UIColor(red: 1/255, green: 122/255, blue: 255/255, alpha: 1), forState: .Normal)
                sendButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
                sendButton.addTarget(self, action: "sendAction", forControlEvents: UIControlEvents.TouchUpInside)
                toolBar.addSubview(sendButton)

                // Auto Layout allows `sendButton` to change width, e.g., for localization.
                textView.setTranslatesAutoresizingMaskIntoConstraints(false)
                sendButton.setTranslatesAutoresizingMaskIntoConstraints(false)
                toolBar.addConstraint(NSLayoutConstraint(item: textView, attribute: .Left, relatedBy: .Equal, toItem: toolBar, attribute: .Left, multiplier: 1, constant: 8))
                toolBar.addConstraint(NSLayoutConstraint(item: textView, attribute: .Top, relatedBy: .Equal, toItem: toolBar, attribute: .Top, multiplier: 1, constant: 7.5))
                toolBar.addConstraint(NSLayoutConstraint(item: textView, attribute: .Right, relatedBy: .Equal, toItem: sendButton, attribute: .Left, multiplier: 1, constant: -2))
                toolBar.addConstraint(NSLayoutConstraint(item: textView, attribute: .Bottom, relatedBy: .Equal, toItem: toolBar, attribute: .Bottom, multiplier: 1, constant: -8))
                toolBar.addConstraint(NSLayoutConstraint(item: sendButton, attribute: .Right, relatedBy: .Equal, toItem: toolBar, attribute: .Right, multiplier: 1, constant: 0))
                toolBar.addConstraint(NSLayoutConstraint(item: sendButton, attribute: .Bottom, relatedBy: .Equal, toItem: toolBar, attribute: .Bottom, multiplier: 1, constant: -4.5))
            }
            return toolBar
        }
    }

    override func canBecomeFirstResponder() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        messages = [
            [
                Message(incoming: true, text: "I really enjoyed programming with you! :-)", sentDate: NSDate(timeIntervalSinceNow: -60*60*24*2-60*60)),
                Message(incoming: false, text: "Thanks! Me too! :-)", sentDate: NSDate(timeIntervalSinceNow: -60*60*24*2))
            ],
            [
                Message(incoming: true, text: "Hey, would you like to spend some time together tonight and work on Acani?", sentDate: NSDate(timeIntervalSinceNow: -33)),
                Message(incoming: false, text: "Sure, I'd love to. How's 6 PM?", sentDate: NSDate(timeIntervalSinceNow: -19)),
                Message(incoming: true, text: "6 sounds good :-)", sentDate: NSDate())
            ]
        ]

        let whiteColor = UIColor.whiteColor()
        view.backgroundColor = whiteColor // smooths push animation

        tableView = UITableView(frame: view.bounds, style: .Plain)
        tableView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        tableView.backgroundColor = whiteColor
        let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: toolBarMinHeight, right: 0)
        tableView.contentInset = edgeInsets
        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .Interactive
        tableView.estimatedRowHeight = 44
        tableView.separatorStyle = .None
        tableView.registerClass(MessageBubbleCell.self, forCellReuseIdentifier: NSStringFromClass(MessageBubbleCell))
        view.addSubview(tableView)

        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "menuControllerWillHide:", name: UIMenuControllerWillHideMenuNotification, object: nil) // #CopyMessage
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func viewDidAppear(animated: Bool)  {
        super.viewDidAppear(animated)
        tableView.flashScrollIndicators()
    }

    override func viewWillDisappear(animated: Bool)  {
        super.viewWillDisappear(animated)
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return messages.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages[section].count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = NSStringFromClass(MessageBubbleCell)
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MessageBubbleCell
        let message = messages[indexPath.section][indexPath.row]
        cell.configureWithMessage(message)
        return cell
    }

    // Reserve row selection #CopyMessage
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }

    func textViewDidChange(textView: UITextView) {
        updateTextViewHeight()
        sendButton.enabled = textView.hasText()
    }

    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo as NSDictionary!
        let frameNew = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let insetNewBottom = tableView.convertRect(frameNew, fromView: nil).height
        let insetOld = tableView.contentInset
        let insetChange = insetNewBottom - insetOld.bottom
        let overflow = tableView.contentSize.height - (tableView.frame.height-insetOld.top-insetOld.bottom)

        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let animations: (() -> Void) = {
            if !(self.tableView.tracking || self.tableView.decelerating) {
                // Move content with keyboard
                if overflow > 0 {                   // scrollable before
                    self.tableView.contentOffset.y += insetChange
                    if self.tableView.contentOffset.y < -insetOld.top {
                        self.tableView.contentOffset.y = -insetOld.top
                    }
                } else if insetChange > -overflow { // scrollable after
                    self.tableView.contentOffset.y += insetChange + overflow
                }
            }
        }
        if duration > 0 {
            let options = UIViewAnimationOptions(UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16)) // http://stackoverflow.com/a/18873820/242933
            UIView.animateWithDuration(duration, delay: 0, options: options, animations: animations, completion: nil)
        } else {
            animations()
        }
    }

    func keyboardDidShow(notification: NSNotification) {
        let userInfo = notification.userInfo as NSDictionary!
        let frameNew = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let insetNewBottom = tableView.convertRect(frameNew, fromView: nil).height

        // Inset `tableView` with keyboard
        let contentOffsetY = tableView.contentOffset.y
        tableView.contentInset.bottom = insetNewBottom
        tableView.scrollIndicatorInsets.bottom = insetNewBottom
        // Prevents jump after keyboard dismissal
        if self.tableView.tracking || self.tableView.decelerating {
            tableView.contentOffset.y = contentOffsetY
        }
    }

    func updateTextViewHeight() {
        let oldHeight = textView.frame.height
        let maxHeight = UIInterfaceOrientationIsPortrait(interfaceOrientation) ? textViewMaxHeight.portrait : textViewMaxHeight.landscape
        var newHeight = min(textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.max)).height, maxHeight)
        #if arch(x86_64) || arch(arm64)
            newHeight = ceil(newHeight)
            #else
            newHeight = CGFloat(ceilf(newHeight.native))
        #endif
        if newHeight != oldHeight {
            toolBar.frame.size.height = newHeight+8*2-0.5
        }
    }

    func sendAction() {
        // Autocomplete text before sending #hack
        textView.resignFirstResponder()
        textView.becomeFirstResponder()

        messages.append([Message(incoming: false, text: textView.text, sentDate: NSDate())])
        textView.text = nil
        updateTextViewHeight()
        sendButton.enabled = false

        let lastSection = tableView.numberOfSections()
        tableView.beginUpdates()
        tableView.insertSections(NSIndexSet(index: lastSection), withRowAnimation: .Automatic)
        tableView.insertRowsAtIndexPaths([
            NSIndexPath(forRow: 0, inSection: lastSection),
            ], withRowAnimation: .Automatic)
        tableView.endUpdates()
        tableViewScrollToBottomAnimated(true)
    }

    func tableViewScrollToBottomAnimated(animated: Bool) {
        let numberOfRows = tableView.numberOfRowsInSection(0)
        if numberOfRows > 0 {
            tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: numberOfRows-1, inSection: 0), atScrollPosition: .Bottom, animated: animated)
        }
    }

    // Handle actions #CopyMessage
    // 1. Select row and show "Copy" menu
    func messageShowMenuAction(gestureRecognizer: UITapGestureRecognizer) {
        let twoTaps = (gestureRecognizer.numberOfTapsRequired == 2)
        let doubleTap = (twoTaps && gestureRecognizer.state == .Ended)
        let longPress = (!twoTaps && gestureRecognizer.state == .Began)
        if doubleTap || longPress {
            let pressedIndexPath = tableView.indexPathForRowAtPoint(gestureRecognizer.locationInView(tableView))!
            tableView.selectRowAtIndexPath(pressedIndexPath, animated: false, scrollPosition: .None)

            let menuController = UIMenuController.sharedMenuController()
            let bubbleImageView = gestureRecognizer.view!
            menuController.setTargetRect(bubbleImageView.frame, inView: bubbleImageView.superview!)
            menuController.menuItems = [UIMenuItem(title: "Copy", action: "messageCopyTextAction:")]
            menuController.setMenuVisible(true, animated: true)
        }
    }
}

// Only show "Copy" when editing `textView` #CopyMessage
class InputTextView: UITextView {
    override func canPerformAction(action: Selector, withSender sender: AnyObject!) -> Bool {
        return super.canPerformAction(action, withSender: sender)
    }
    
    // More specific than implementing `nextResponder` to return `delegate`, which might cause side effects?
    func messageCopyTextAction(menuController: UIMenuController) {
        //(delegate as! ChatViewController).messageCopyTextAction(menuController)
    }
}