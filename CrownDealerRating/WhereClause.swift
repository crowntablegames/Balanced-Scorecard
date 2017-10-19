//
//  WhereClause.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 4/8/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import Foundation

class WhereClause {
    
    private let fields : [Field]!
    private var fieldValues : Any!
    private let clauseOperators : [ClauseOperator]!
    private let clauseConditionalOperators : [ConditionalOperator]?
    
    init(fields : [Field], orderedClauseOperators : [ClauseOperator], orderedConditionalOperators : [ConditionalOperator])  {
        self.fields = fields
        self.clauseOperators = orderedClauseOperators
        self.clauseConditionalOperators = orderedConditionalOperators
    }

    // Returns the WHERE clause as a string. Throws an error if the query is not formatted correctly.
    public func asString() throws -> String {
        
        if fields.count - clauseConditionalOperators!.count > 1 {
            throw WhereClauseErrorType.notEnoughConditionalOperators
        }
        if fields.count - clauseConditionalOperators!.count < 1 {
            throw WhereClauseErrorType.tooManyConditionalOperators
        }
       
        var clauseString : String = "WHERE "
        
        // Iterate through each of the fields
        for index in 0...fields.count-1 {
            let field = fields[index]
            
            // If there is more than 1 field then add a conditional operator to the query
            if index > 0 {
                clauseString = "\(clauseString) \(clauseConditionalOperators![index-1].rawValue)"
            }
            
            clauseString = "\(clauseString) \(field.fieldName!) \(clauseOperators[index].rawValue)"
            
            if field.fieldValue is String {
                clauseString = "\(clauseString) '\(field.fieldValue!)'"
            }
            else {
                clauseString = "\(clauseString) \(field.fieldValue!)"
            }
        }
      
        return clauseString
    }
}

// Operators used to compare fields
public enum ClauseOperator : String {
    case equal = "="
    case notEqual = "!="
    case greaterThan = ">"
    case lessThan = "<"
    case greaterOrEqual = ">="
    case lessThanOrEqual = "<="
    case betweenInclusive = "BETWEEN"
    case like = "LIKE"
    case whereIn = "IN"
}

//Conditional operators
public enum ConditionalOperator : String {
    
    case and = "AND"
    case or = "OR"
    case not = "NOT"
}

//Errors thrown by the Where Clause object.
public enum WhereClauseErrorType : Error {
    case tooManyConditionalOperators
    case notEnoughConditionalOperators
}
