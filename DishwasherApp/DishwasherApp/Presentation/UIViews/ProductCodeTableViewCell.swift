//
//  ProductCodeTableViewCell.swift
//  DishwasherApp
//
//  Created by Matt Harding on 24/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import UIKit

class ProductCodeTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    
    var presenter: ProductCodeCellPresenter? { didSet {
        
        titleLabel.text = presenter?.text
        }
    }
}
