//
//  JoinClause.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 5/8/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import Foundation

class JoinClause {
    
    var joins : [Join] = []
    
    init(joins : [Join]) {
        self.joins = joins
    }
    
    public func asString() throws -> String {
        var joinString = ""
        for index in 0...joins.count-1 {
            let join = joins[index]
            if index > 0 {
                joinString = "\(joinString) "
            }
            joinString = "\(joinString)\(join.clauseType!.rawValue) JOIN \(join.joinTableName!) ON \(join.joinTableName!).\(join.joinTableValue!) \(join.clauseOperator!.rawValue) \(join.relatedTableName!).\(join.relatedTableValue!)"
            
        }
        return joinString
    }
}

struct Join {
    
    var joinTableName : String!
    var joinTableValue : String!
    
    var relatedTableName : String!
    var relatedTableValue:  String!
    
    var clauseType : JoinClauseType!
    var clauseOperator : ClauseOperator!
    
    init(joinTableName : String, joinTableValue : String, relatedTableName : String, relatedTableValue : String, clauseType : JoinClauseType, clauseOperator : ClauseOperator) {
        self.joinTableName = joinTableName
        self.joinTableValue = joinTableValue
        self.relatedTableName = relatedTableName
        self.relatedTableValue = relatedTableValue
        self.clauseType = clauseType
        self.clauseOperator = clauseOperator
    }
}

public enum JoinClauseType : String {
    case inner = "INNER"
    case left = "LEFT"
    case right = "RIGHT"
    case fullOuter = "FULL OUTER"

}

public enum JoinClauseError : Error {
    case joinError
}
