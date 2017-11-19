//
//  Table.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 30/6/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import Foundation

/* This class is made to represent information regarding a Table Games
    table. 
 */
public class Table {
    
    var tableNumber : NSNumber?
    var gameType : GameType?
    var dealer : Dealer?
    
    init(tableNumber: NSNumber, gameType : GameType, dealer : Dealer) {
        self.tableNumber = tableNumber
        self.gameType = gameType
        self.dealer = dealer
    }
    
    public init(tableDictionary : NSDictionary) {
        let tableNumber = Int(tableDictionary.value(forKey: "tableNumber") as! String)
        self.tableNumber = NSNumber(value: tableNumber!)
        let gameType = tableDictionary.value(forKey: "gameType") as! String
        self.gameType = GameType.init(rawValue: gameType)
        self.dealer = Dealer(dealerDictionary: tableDictionary)
    }
    
    public func toString() -> String{
        
        return "\(tableNumber!): \(String(describing: self.gameType!.rawValue))"
    }
    
    // Returns the object as a JSON compatible NSDictionary.
    public func asDictionary()-> NSDictionary {
        
        let dict : NSDictionary = ["dealerID" : self.tableNumber! as NSNumber,
                                   "gameType" : self.gameType!.rawValue as NSString,
                                   "dealer" : self.dealer!.asDictionary() as NSDictionary
        ]
        
        
        return dict
        
    }
    
    // Returns an array of table objects from a given NSArray of table dictionaries
    public static func tablesFrom(tableDictionaryArray : NSArray) -> [Table] {
        
        var tables : [Table] = []
        
        for table in tableDictionaryArray {
            
            let tableObject = Table(tableDictionary: table as! NSDictionary)
            tables.append(tableObject)
        }
        
        
        return tables
    }
}

// Represents the game type assigned to each table.
public enum GameType : String {
    
    case crownBlackjack = "Crown Blackjack"
    case blackjackPlus = "Blackjack Plus"
    case casinoWar = "Casino War"
    case bigWheel = "Big Wheel"
    case baccarat = "Baccarat"
    case poker = "Poker"
    case carribeanStud = "Caribbean Stud"
    case pontoon = "Pontoon"
}
