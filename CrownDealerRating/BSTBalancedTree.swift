//
//  BSTBalancedTree.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 3/11/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import Foundation

public class BSTBalancedTree<Value> {
    
    private(set) var root : BSTNode<Value>?
    
    public init(rootValue: Value) {
        let rootNode = BSTNode<Value>(rank: 1, value: rootValue)
        self.root = rootNode
    }
    
    public func insert(rank: Int, value: Value) {
        
    }
    
    public func insert(node : BSTNode<Value>) {
        
    }
    
    
    
}

public class BSTNode<Value> {
    
    private(set) var rank : Int
    private(set) var value : Value
    
    private(set) var leftChild : BSTNode?
    private(set) var rightChild : BSTNode?
    
    
    
    public init(rank: Int, value : Value) {
        self.rank = rank
        self.value = value
    }

    
}
