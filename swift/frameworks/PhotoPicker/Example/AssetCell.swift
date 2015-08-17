//
//  AssetCell.swift
//  Example
//
//  Created by Hirohisa Kawasaki on 8/17/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

class AssetCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectedMaskView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override var selected: Bool {
        didSet {
            update()
        }
    }

    func update() {
        selectedMaskView.hidden = !selected
    }

}
