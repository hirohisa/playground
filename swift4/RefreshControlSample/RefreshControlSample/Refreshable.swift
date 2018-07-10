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

protocol UIImpactFeedbackGeneratorable {
    func prepare()
    func impactOccurred()
}

@available(iOS 10.0, *)
extension UIImpactFeedbackGenerator: UIImpactFeedbackGeneratorable {
}

protocol RefreshHeaderView {
    func load(state: RefreshState)
}

protocol RefreshableView {
    typealias Block = () -> Void

    var state: RefreshState { get set }

    var refreshHeaderView: UIView { get }
    func stopAnimating()

    // haptic
    var feedbackGenerator: UIImpactFeedbackGeneratorable? { get }

    // refresh
    var onRefresh: Block? { get }
    // load more
    var onLoadMore: Block? { get }

    func observeScrolling()
    func observeDragging()
}

private var refreshableViewDefaultContentInset = 0

extension RefreshableView where Self: UIScrollView {

    var defaultContentInset: UIEdgeInsets {
        get {
            return objc_getAssociatedObject(self, &refreshableViewDefaultContentInset) as? UIEdgeInsets ?? .zero
        }
        set {
            objc_setAssociatedObject(self, &refreshableViewDefaultContentInset, newValue, objc_AssociationPolicy(rawValue: 3)!)
        }
    }

    func observeScrolling() {
        switch state {
        case .default:
            if isScrollingForRefreshing() {
                var varSelf = self
                varSelf.defaultContentInset = contentInset
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

    func observeDragging() {
        switch state {
        case .isRefreshing:
            if !isDragging {
                let top = refreshHeaderView.frame.height + defaultContentInset.top
                UIView.animate(withDuration: 0.25, animations: {
                    self.contentInset = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
                }, completion: { _ in })
            }
        default:
            if isDragging {
                feedbackGenerator?.prepare()
            }
            break
        }
    }

    // refresh
    private func isScrollingForRefreshing() -> Bool {
        if contentOffset.y < -1 * (refreshHeaderView.frame.height + defaultContentInset.top) {
            return true
        }
        return false
    }

    private func refresh() {
        guard let onRefresh = onRefresh else { return }
        var varSelf = self
        varSelf.state = .isRefreshing
        feedbackGenerator?.impactOccurred()
        if let refreshHeaderView = refreshHeaderView as? RefreshHeaderView {
            refreshHeaderView.load(state: .isRefreshing)
        }
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
            if !isDragging {
                stopRefreshing()
            }
        case .isLoadingMore:
            varSelf.state = .didLoadingMore
        default:
            break
        }
    }

    private func stopRefreshing() {
        var varSelf = self
        varSelf.state = .stopRefreshing
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { [weak self] in
            guard var weakSelf = self else { return }
            UIView.animate(withDuration: 0.25, animations: {
                weakSelf.contentInset = weakSelf.defaultContentInset
            }, completion: { _ in
                weakSelf.state = .default
                if let refreshHeaderView = weakSelf.refreshHeaderView as? RefreshHeaderView {
                    refreshHeaderView.load(state: .default)
                }
            })
        })
    }

    private func stopLoadingMore() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { [weak self] in
            guard var weakSelf = self else { return }
            weakSelf.state = .default
        })
    }
}

class RefreshableTableView: UITableView, RefreshableView {

    let feedbackGenerator: UIImpactFeedbackGeneratorable? = {
        if #available(iOS 10.0, *) {
            return UIImpactFeedbackGenerator(style: .light)
        }
        return nil
    }()

    var state: RefreshState = .default
    var onRefresh: Block?
    var onLoadMore: Block?

    var refreshHeaderView: UIView = RefreshView(frame: .zero)

    override func awakeFromNib() {
        super.awakeFromNib()

        refreshHeaderView.translatesAutoresizingMaskIntoConstraints = true
        let height: CGFloat = 52
        refreshHeaderView.frame = CGRect(x: 0, y: -height, width: frame.width, height: height)
        addSubview(refreshHeaderView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if refreshHeaderView.frame.width != frame.width {
            let aFrame = refreshHeaderView.frame
            refreshHeaderView.frame = CGRect(x: aFrame.minX, y: aFrame.minY, width: frame.width, height: aFrame.height)
        }
    }

}
