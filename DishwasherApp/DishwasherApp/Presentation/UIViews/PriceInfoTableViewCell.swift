//
//  PriceInfoTableViewCell.swift
//  DishwasherApp
//
//  Created by Matt Harding on 24/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import UIKit

class PriceInfoTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    var presenter: PriceInfoCellPresenter? { didSet {
        titleLabel.text = presenter?.title
        messageLabel.text = presenter?.priorityMessage
        descriptionLabel.text = presenter?.description
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
