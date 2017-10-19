//
//  DealerDatabaseQuery.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 27/7/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import Foundation

class DealerDatabaseQuery {
    
    private var queryType : DealerDatabaseQueryType
    private var tableName : String!
    private var dataDictionary : NSDictionary!
    
    init(queryType : DealerDatabaseQueryType, tableName : String, dataDictionary : NSDictionary) {
        self.queryType = queryType
        self.tableName = tableName
        self.dataDictionary = dataDictionary
    }
    
    public func getQueryType() -> DealerDatabaseQueryType {
        return self.queryType
    }
    
    public func createQueryDictionary() -> NSDictionary? {
        
        var queryDictionary : NSDictionary?
        
        switch queryType {
        case DealerDatabaseQueryType.insert:
            queryDictionary = ["queryType" : queryType.rawValue, "data" : dataDictionary, "tableName" : self.tableName]
        case DealerDatabaseQueryType.select:
            queryDictionary = ["queryType" : queryType.rawValue, "data" : dataDictionary, "tableName" : self.tableName]
        default: break
            
        }
        return queryDictionary
    }
    
    public enum DealerDatabaseQueryType : String {
        case insert = "insert"
        case select = "select"
    }
    
    // Table Names 
    public enum TableName : String {
        case dealer = "Dealer"
        case table = "Table"
        case assessment = "Assessment"
    }
}
