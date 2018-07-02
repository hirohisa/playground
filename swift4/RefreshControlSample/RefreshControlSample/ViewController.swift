//
//  ViewController.swift
//  RefreshControlSample
//
//  Created by Hirohisa Kawasaki on 2018/07/02.
//  Copyright © 2018 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

class RefreshableTableView: UITableView {
    typealias Block = () -> Void

    var onRefresh: Block?
    var onLoadMore: Block?

    private var isLoadingMore = false
    private var observation: NSKeyValueObservation?

    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }

    private func setUp() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)

        observation?.invalidate()
        observation = observe(\.contentOffset) { [weak self] (_, change) in
            guard let weakSelf = self else { return }

            if weakSelf.isScrollingOverBottom() {
                weakSelf.loadMore()
            }
        }
    }

    @objc private func refresh(sender: UIRefreshControl) {
        guard let onRefresh = onRefresh else { return }
        onRefresh()
    }

    func stopAnimating() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.isLoadingMore = false
            self.refreshControl?.endRefreshing()
        })
    }

    private func isScrollingOverBottom() -> Bool {
        let buffer: CGFloat = 0
        return contentSize.height <= contentOffset.y + frame.size.height + buffer
    }

    private func loadMore() {
        guard let onLoadMore = onLoadMore, !isLoadingMore else { return }
        isLoadingMore = true
        onLoadMore()
    }

    deinit {
        observation?.invalidate()
    }

}

class ViewController: UIViewController {

    @IBOutlet weak var tableView: RefreshableTableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.onRefresh = {
            print("refreshing")
            self.tableView.stopAnimating()
        }

        tableView.onLoadMore = {
            print("loading more")
            self.tableView.stopAnimating()
        }
    }

}

