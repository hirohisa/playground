//
//  Refreshable.swift
//
//  Created by Hirohisa Kawasaki on 2018/07/02.
//  Copyright © 2018 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

enum RefreshState {
    case `default`
    case isRefreshing
    case didRefreshing
    case stopRefreshing
    case isLoadingMore
    case didLoadingMore
}

protocol RefreshHeaderView {
    func load(state: RefreshState)
}

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

protocol Refreshable {
    typealias Block = () -> Void

    var state: RefreshState { get set }
    var observation: NSKeyValueObservation? { get set }
    var refreshHeaderHeight: CGFloat { get }
    var defaultContentInsets: UIEdgeInsets { get }

    var refreshHeaderView: UIView { get }

    func setUp()
    func stopAnimating()

    // refresh
    var onRefresh: Block? { get }
    // load more
    var onLoadMore: Block? { get }
}

extension Refreshable where Self: UIScrollView {

    var defaultContentInsets: UIEdgeInsets { return .zero }
    var refreshHeaderHeight: CGFloat { return 52 }

    func setUp() {
        var varSelf = self

        refreshHeaderView.translatesAutoresizingMaskIntoConstraints = true
        refreshHeaderView.frame = CGRect(x: 0, y: -refreshHeaderHeight, width: frame.width, height: refreshHeaderHeight)
        addSubview(refreshHeaderView)


        observation?.invalidate()
        varSelf.observation = observe(\.contentOffset) { [weak self] (_, change) in
            guard let weakSelf = self else { return }
            weakSelf.observeScrolling()
        }
    }

    private func observeScrolling() {
        switch state {
        case .default:
            if isScrollingForRefreshing() {
                refresh()
            }
            if isScrollingOverBottom() {
                loadMore()
            }
        case .didRefreshing:
            if !isDragging {
                stopRefreshing()
            }
        case .didLoadingMore:
            if !isDragging {
                stopRefreshing()
            }
        default:
            break
        }
    }

    // refresh
    private func isScrollingForRefreshing() -> Bool {
        if contentOffset.y < -1 * refreshHeaderHeight {
            return true
        }
        return false
    }

    private func refresh() {
        guard let onRefresh = onRefresh else { return }
        var varSelf = self
        varSelf.state = .isRefreshing
        if let refreshHeaderView = refreshHeaderView as? RefreshHeaderView {
            refreshHeaderView.load(state: .isRefreshing)
        }
        UIView.animate(withDuration: 0.3, animations: {
            varSelf.contentInset = UIEdgeInsets(top: varSelf.refreshHeaderHeight, left: 0, bottom: 0, right: 0)
        })
        onRefresh()
    }

    // load more
    private func isScrollingOverBottom() -> Bool {
        if contentSize.height == 0 || frame.size.height == 0 {
            return false
        }

        return contentSize.height < contentOffset.y + frame.height - UIApplication.shared.statusBarFrame.height
    }

    private func loadMore() {
        guard let onLoadMore = onLoadMore, !isDragging else { return }
        var varSelf = self
        varSelf.state = .isLoadingMore
        onLoadMore()
    }

    func stopAnimating() {
        var varSelf = self
        switch state {
        case .isRefreshing:
            varSelf.state = .didRefreshing
        case .isLoadingMore:
            varSelf.state = .didLoadingMore
        default:
            break
        }
    }

    private func stopRefreshing() {
        var varSelf = self
        varSelf.state = .stopRefreshing
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
            guard var weakSelf = self else { return }
            UIView.animate(withDuration: 0.3, animations: {
                weakSelf.contentInset = weakSelf.defaultContentInsets
            }, completion: { _ in
                weakSelf.state = .default
                if let refreshHeaderView = weakSelf.refreshHeaderView as? RefreshHeaderView {
                    refreshHeaderView.load(state: .default)
                }
            })
        })
    }

    private func stopLoadingMore() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
            guard var weakSelf = self else { return }
            weakSelf.state = .default
        })
    }
}

class RefreshableTableView: UITableView, Refreshable {
    var state: RefreshState = .default {
        didSet {
            if state == .default {
                reloadData()
            }
        }
    }
    var onRefresh: Block?
    var onLoadMore: Block?
    var observation: NSKeyValueObservation?

    var refreshHeaderView: UIView = RefreshView(frame: .zero)

    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if refreshHeaderView.frame.width != frame.width {
            let aFrame = refreshHeaderView.frame
            refreshHeaderView.frame = CGRect(x: aFrame.minX, y: aFrame.minY, width: frame.width, height: aFrame.height)
        }
    }

    deinit {
        observation?.invalidate()
    }

}
