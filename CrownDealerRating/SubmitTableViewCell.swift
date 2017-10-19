//
//  SubmitTableViewCell.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 14/7/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import UIKit

protocol SubmitCellDelegate {
    func submitButtonPressed()
}

class SubmitTableViewCell: UITableViewCell {

    @IBOutlet weak var submitButton: UIButton!
    
    var delegate : SubmitCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.submitButton.setTitle("Submit", for: .normal)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func submitPressed() {
        
        print("Submit Pressed")
        self.delegate?.submitButtonPressed()
    }
}
