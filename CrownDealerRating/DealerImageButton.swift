//
//  DealerImageView.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 30/6/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import UIKit

class DealerImageButton : UIButton {


 
    public func editRadius() {
        self.layer.cornerRadius = self.frame.width/2
        print(self.layer.cornerRadius)
    }
    
    public func show(border : Bool) {
        
        if(border) {
            self.layer.borderWidth = 7.0
            self.layer.borderColor = UIColor.blue.cgColor
        }
        else {
            self.layer.borderWidth = 0.0
            self.layer.borderColor = UIColor.clear.cgColor
        }
        
    }
    
}
