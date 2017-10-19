//
//  Dealer.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 30/6/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import Foundation
import UIKit

class Dealer {
    
    private var id : NSNumber?
    private var firstName : String?
    private var secondName : String?
    private(set) var area : Area?
    private var games : [GameType] = []
    private var photoURLString : String?
    private(set) var dealerImage : UIImage?
    
    init(firstName : String, secondName : String, id : NSNumber) {
        self.firstName = firstName
        self.secondName = secondName
        self.id = id
    }
    
    init?(dealerDictionary : NSDictionary) {
        let firstName = dealerDictionary.value(forKey: "firstName") as? String
        let secondName = dealerDictionary.value(forKey: "lastName") as? String
        let idString = dealerDictionary.value(forKey: "dealerID") as? String
        let dealerArea = dealerDictionary.value(forKey: "area") as? String
        let photoURLString = dealerDictionary.value(forKey: "photoURL") as? String
        if let id = Int(idString!) {
            
            self.id = id as NSNumber
            self.firstName = firstName
            self.secondName = secondName
            self.area = Area.init(rawValue: dealerArea!)
            self.photoURLString = photoURLString
            
        }
        else {
            return nil
        }
            
        
    }
    
    func downloadDealerImage(completion: @escaping () -> Void) {
        
        
        if self.photoURLString != nil {
            let url = URL(string: self.photoURLString!) 
            
            
                var image : UIImage?
                let task = URLSession.shared.dataTask(with: url!) {data, response, error in
                    
                    if error != nil {
                        
                    }
                    else {
                        image = UIImage(data: data!)
                    }
                    
                    self.dealerImage = image
                    
                    DispatchQueue.main.async {
                        completion()
                        
                    }
                }
                
                task.resume()
        }
        
        
    }
    
    func toString() ->String {
        
        return "\(self.id!) : \(self.firstName!) \(self.secondName!)"
    }
    
    func getFirstName() -> String {
        return self.firstName!
    }
    func getSecondName() -> String {
        return self.secondName!
    }
    func getID() -> NSNumber {
        return self.id!
    }
    
    public func asDictionary()-> NSDictionary {
        
        let dict : NSDictionary = ["id" : self.id! as NSNumber,
            "firstName" : self.firstName! as NSString,
            "lastName" : self.secondName! as NSString
        ]
        
        
        return dict
        
    }
}

public enum Area : String {
    
    case EastWest = "East West"
    case Central  = "Central"
    case Level1 = "Level 1"
    case Premium = "Premium"
    case VVIP = "VVIP"
    
}
