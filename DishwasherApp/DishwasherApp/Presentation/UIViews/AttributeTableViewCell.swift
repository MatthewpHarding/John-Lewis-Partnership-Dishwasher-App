//
//  AttributeTableViewCell.swift
//  DishwasherApp
//
//  Created by Matt Harding on 24/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import UIKit

class AttributeTableViewCell: UITableViewCell {
    
    @IBOutlet var leftLabel: UILabel!
    @IBOutlet var rightLabel: UILabel!
    
    var presenter: AttributeCellPresenter? { didSet {
        leftLabel.text = presenter?.leftText
        rightLabel.text = presenter?.rightText
        }
    }
  
}
