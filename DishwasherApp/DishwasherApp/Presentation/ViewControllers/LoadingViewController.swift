//
//  LoadingViewController.swift
//  DishwasherApp
//
//  Created by Matt Harding on 26/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import UIKit

protocol LoadingViewControllerDelegate {
    func retry(forLoadingViewController: LoadingViewController)
}

class LoadingViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var actionButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var delegate: LoadingViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        
        titleLabel.text = NSLocalizedString("Connection Troubles?", comment: "")
        subtitleLabel.text = NSLocalizedString("Please check your data connection and try again", comment: "")
        actionButton.setTitle(NSLocalizedString("Tap to Refresh", comment: ""), for: .normal)
        activityIndicator.stopAnimating()
    }
    
    func startRefreshing(whileHidingContent hideContent: Bool = false) {
        
        if hideContent {
            titleLabel.alpha = 0.0
            actionButton.alpha = 0.0
        }
        subtitleLabel.alpha = 0.0
        activityIndicator.startAnimating()
        actionButton.isEnabled = false
    }
    
    func stopRefreshing() {
        
        titleLabel.alpha = 1.0
        subtitleLabel.alpha = 1.0
        actionButton.alpha = 1.0
        
        activityIndicator.stopAnimating()
        actionButton.isEnabled = true
    }

    @IBAction private func retryPressed() {
        delegate?.retry(forLoadingViewController: self)
    }
}
