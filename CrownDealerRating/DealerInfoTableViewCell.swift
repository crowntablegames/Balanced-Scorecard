//
//  DealerInfoTableViewCell.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 14/7/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import UIKit

class DealerInfoTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
