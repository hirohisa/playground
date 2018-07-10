//
//  PullToRefreshViewController.swift
//  RefreshControlSample
//
//  Created by Hirohisa Kawasaki on 7/9/18.
//  Copyright © 2018 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

class RefreshView: UIView, RefreshHeaderView {

    let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        addSubview(indicator)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        indicator.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
    }

    func load(state: RefreshState) {
        switch state {
        case .default, .isLoadingMore:
            indicator.stopAnimating()
        case .isRefreshing:
            indicator.startAnimating()
        default:
            break
        }
    }
}

class PullToRefreshViewController: UIViewController, UIScrollViewDelegate {

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if let scrollView = scrollView as? RefreshableView {
            scrollView.observeDragging()
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let scrollView = scrollView as? RefreshableView {
            scrollView.observeScrolling()
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let scrollView = scrollView as? RefreshableView {
            scrollView.observeDragging()
        }
    }
}
