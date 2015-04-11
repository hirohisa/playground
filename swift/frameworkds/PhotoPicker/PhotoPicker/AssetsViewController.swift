//
//  AssetsViewController.swift
//  PhotoPicker
//
//  Created by Hirohisa Kawasaki on 4/11/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit


extension PhotoPicker.AlbumViewController {

    class Cell: UICollectionViewCell {
        let imageView = UIImageView(frame: CGRectZero)

        override func layoutSubviews() {
            super.layoutSubviews()
            imageView.frame = contentView.bounds
            contentView.addSubview(imageView)
        }
    }

    class AssetsViewController: UICollectionViewController {

        required override init() {
            let collectionViewLayout = UICollectionViewFlowLayout()
            super.init(collectionViewLayout: collectionViewLayout)
        }

        required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}


extension PhotoPicker.AlbumViewController.AssetsViewController {

}