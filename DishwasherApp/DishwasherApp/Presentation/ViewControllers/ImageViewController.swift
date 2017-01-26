//
//  ImageViewController.swift
//  DishwasherApp
//
//  Created by Matt Harding on 25/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import UIKit
import Kingfisher

class ImageViewController: UIViewController {
    
    let imageView = UIImageView()
    var imageURL: URL? = nil { didSet {
        
        guard oldValue != imageURL else {
            return
        }
        
        imageView.kf.cancelDownloadTask()
        imageView.kf.setImage(with: imageURL, options: [.transition(.fade(0.1))])
        }
    }
    
    override func loadView() {
        super.loadView()
        
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.translatesAutoresizingMaskIntoConstraints = true
        imageView.contentMode = .scaleAspectFit
        imageView.frame.size = view.bounds.size
        view.addSubview(imageView)
    }
}
