//
//  ViewController.swift
//  RefreshControlSample
//
//  Created by Hirohisa Kawasaki on 2018/07/02.
//  Copyright © 2018 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

protocol Refreshable {
    typealias Block = () -> Void

    func stopAnimating()

    // refresh
    var onRefresh: Block? { get }
    func refresh()

    // load more
    var onLoadMore: Block? { get }
    func isScrollingOverBottom() -> Bool
    var isLoadingMore: Bool { get set }
    var observation: NSKeyValueObservation? { get set }
    mutating func loadMore()
}

extension Refreshable where Self: UIScrollView {

    func refresh() {
        guard let onRefresh = onRefresh else { return }
        onRefresh()
    }

    mutating func loadMore() {
        guard let onLoadMore = onLoadMore, !isLoadingMore else { return }
        isLoadingMore = true
        onLoadMore()
    }

    func isScrollingOverBottom() -> Bool {
        if contentSize.height == 0 || frame.size.height == 0 {
            return false
        }

        let buffer: CGFloat = 0
        return contentSize.height <= contentOffset.y + frame.size.height + buffer
    }

    func stopAnimating() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
            guard var weakSelf = self else { return }
            weakSelf.isLoadingMore = false
            weakSelf.refreshControl?.endRefreshing()
        })
    }

}

class RefreshableTableView: UITableView, Refreshable {
    var onRefresh: Block?
    var onLoadMore: Block?
    var isLoadingMore = false

    var observation: NSKeyValueObservation?

    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }

    private func setUp() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)

        observation?.invalidate()
        observation = observe(\.contentOffset) { [weak self] (_, change) in
            guard var weakSelf = self else { return }

            if weakSelf.isScrollingOverBottom() {
                weakSelf.loadMore()
            }
        }
    }

    @objc private func refresh(sender: UIRefreshControl) {
        guard let onRefresh = onRefresh else { return }
        onRefresh()
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

