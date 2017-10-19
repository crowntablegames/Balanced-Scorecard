//
//  SelectQuery.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 4/8/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import Foundation

class SelectQuery : DatabaseQuery {
    
    //An array of the fields to select from a table
    public var fields : [Field]!
    
    //An array of tablesNames. Must be ordered in how they will appear in the query.
    public var tableName : String!
    
    public var distinctResults : Bool!
    
    public var whereClause : WhereClause?
    
    public var joinClause : JoinClause?
    
    
    init(fields : [Field], tableName : String, distinctResults : Bool, whereClause : WhereClause?, joinClause : JoinClause?) {
        self.fields = fields
        self.tableName = tableName
        self.distinctResults = distinctResults
        self.whereClause = whereClause
        self.joinClause = joinClause
    }
    
    public func asString() throws -> String {
        
        var queryString = "SELECT "
        
        if self.distinctResults {
            queryString = "\(queryString) DISTINCT "
        }
        
        for index in 0...self.fields.count-1 {
            let field = self.fields[index]
            
            queryString = "\(queryString) \(field.fieldName!)"
            
            if index > 0 && index < self.fields.count - 1 {
                queryString = "\(queryString),"
            }
        }
        
        queryString = "\(queryString) FROM \(self.tableName!)"
        
        if (self.joinClause != nil) {
            do {
                try queryString = "\(queryString) \(self.joinClause!.asString())"
            }
            catch let e {
                print(e.localizedDescription)
            }
        }
        
        if (self.whereClause != nil) {
            do {
             try queryString = "\(queryString) \(self.whereClause!.asString())"
            }
            catch let e {
                print(e.localizedDescription)
            }
        }
        
        return queryString
    }
}
