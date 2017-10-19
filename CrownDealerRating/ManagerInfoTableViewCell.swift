//
//  ManagerInfoTableViewCell.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 8/9/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import UIKit

class ManagerInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var managerNameLabel : UILabel!
    @IBOutlet weak var managerIDLabel : UILabel!
    @IBOutlet weak var numberOfAssessmentsLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
