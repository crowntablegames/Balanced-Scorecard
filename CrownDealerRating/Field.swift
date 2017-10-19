//
//  Field.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 5/8/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import Foundation

struct Field {
    
    var fieldName : String!
    var fieldValue : Any!
    
    init(fieldName : String, fieldValue : Any) {
        self.fieldName = fieldName
        self.fieldValue = fieldValue
    }
}
