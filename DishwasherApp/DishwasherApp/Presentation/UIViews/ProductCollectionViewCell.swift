//
//  ProductCollectionViewCell.swift
//  DishwasherApp
//
//  Created by Matt Harding on 22/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import UIKit
import Kingfisher

class ProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    
    var imageUrl: URL? {
        didSet {
            guard let url = imageUrl else {
                cancelImageDownload()
                return
            }
            
            imageView.kf.setImage(with: url, options: [.transition(.fade(0.1))])
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancelImageDownload()
    }
    
    private func cancelImageDownload() {
        imageView.kf.cancelDownloadTask()
    }

    
}
