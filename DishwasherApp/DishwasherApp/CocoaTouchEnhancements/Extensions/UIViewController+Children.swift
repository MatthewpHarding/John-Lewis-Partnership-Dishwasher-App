//
//  UIViewController+Children.swift
//  DishwasherApp
//
//  Created by Matt Harding on 26/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func add(_ childViewController: UIViewController, toView parentView: UIView) {
        
        guard let subview = childViewController.view else {
            return
        }
        
        childViewController.willMove(toParentViewController: self)
        addChildViewController(childViewController)
        parentView.addSubview(subview)
        childViewController.didMove(toParentViewController: self)
    }
}
