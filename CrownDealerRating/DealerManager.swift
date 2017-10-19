//
//  DealerManager.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 17/8/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import Foundation

class DealerManager {
    
    public static var shared : DealerManager = DealerManager()
    private(set) var dealers : [Dealer] = []
    
    init() {
        
    }
    
    public func downloadAllDealers() {
        let selectQuery : SelectQuery = {
            
            let fields = [Field.init(fieldName: "*", fieldValue: "")]
            
            return SelectQuery(fields: fields, tableName: "Dealer", distinctResults: false, whereClause: nil, joinClause: nil)
        }()
        
        do {
            let dictionary : NSDictionary = try ["query" : selectQuery.asString()]
            NetworkManager.post(jsonObject: dictionary, toURLPath: "http://18.221.45.138/dealerDatabase.php") {
                data, error in
                
                if error != nil {
                    
                }
                else {
                    self.dealers = []
                    if data != nil {
                        do {
                            let jsonArray = try JSONSerialization.jsonObject(with: data!, options: []) as! NSArray
                            
                            for dealerDictionary in jsonArray {
                                
                                let dealer = Dealer(dealerDictionary: dealerDictionary as! NSDictionary)
                                
                                self.dealers.append(dealer!)
                            }
                            
                        }
                        catch let er {
                            print("JSON Error")
                            print(er.localizedDescription)
                        }
                        
                        
                    }
                }
                
                
            }
            
        }
        catch let error {
            print(error.localizedDescription)
        }
        
        
    }
}
