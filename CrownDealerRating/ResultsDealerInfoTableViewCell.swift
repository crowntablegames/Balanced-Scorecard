//
//  ResultsDealerInfoTableViewCell.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 17/8/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import UIKit


class ResultsDealerInfoTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    
    
    @IBOutlet weak var dealerImage: DealerImageButton!
    @IBOutlet weak var dealerIDLabel: UILabel!
    @IBOutlet weak var dealerAreaLabel: UILabel!
    @IBOutlet weak var dealerNameLabel: UILabel!
    
    // MARK: - Button Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    
    // MARK: - Custom Methods
    
    /**
     Updates the cell with the details from a dealer object.
     
     - parameter dealer: The dealer object who's details are to populate the cell.
     */
    public func updateCellLabelsWith(dealer : Dealer) {
        self.dealerNameLabel.text = "\(dealer.getFirstName()) \(dealer.getSecondName())"
        self.dealerIDLabel.text = "\(dealer.getID())"
        self.dealerAreaLabel.text = "\(dealer.area!.rawValue)"
        self.dealerImage.imageView!.contentMode = .scaleAspectFit
        dealer.downloadDealerImage {
            self.dealerImage.setImage(dealer.dealerImage, for: .normal)
        }
    }

}
