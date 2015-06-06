//
//  ViewController.swift
//  UIViewControllerInteractiveTransitioningSample
//
//  Created by Hirohisa Kawasaki on 6/7/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        let count = navigationController!.viewControllers.count
        title = "current: \(count)"

        button.addTarget(self, action: "pushToNext", forControlEvents: .TouchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func pushToNext() {
        navigationController?.delegate = self
        if let viewController = storyboard?.instantiateViewControllerWithIdentifier("ViewController") as? ViewController {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension ViewController: UINavigationControllerDelegate {

    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        return nil
    }


    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {

        return InteractiveTransitioningController()
    }
}