//
//  Ladder.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 27/10/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import Foundation

/**
 * A Binary Search Tree that models the behaviour of a ladder.
 * Unlike traditional BST's, the values for nodes to the left of a root node
 * are ranked lower and nodes to the right are ranked higher (1 being the highest).
 *
 * Example:
 *
 
           4
         /   \
       6       2
     /   \   /   \
    7      5 3     1
 */
public class BSTLadder<Value: Equatable> {
    
    private(set) public var root : LadderNode<Value>?
    private(set) public var size : Int = 0
    
    
    /// Initialises a new tree with only 1 node from the given value.
    public init(rootValue: Value) {
        let rootNode = LadderNode<Value>(rank: 1, value: rootValue)
        self.size += 1
        self.root = rootNode
    }
    
    /** Initialises the tree based on an ordered set of values. These values must be
     ordered in accordance with their rank. e.g The values 1,2,3,4 wont necessarily be
     ordered 1,2,3,4 in the array if the number 3 is the most highest ranked value.
     */
    public init(rankedArray: [Value]) {
        guard rankedArray.count > 0 else {return }
        self.size = rankedArray.count
        self.root = LadderNode(rank: 0, value: rankedArray[0])
        self.build(with: rankedArray)
    }
    
    /// Insert a new node with a given rank and value.
    public func insert(at rank: Int, value: Value) {
        guard rank > 0  else {return}
        guard rank <= self.size + 1 else { print("Rank is Greater Than Size Of Tree")
            return}
        
        var valueArray = inorderArray(rootNode: self.root)
        valueArray.insert(value, at: rank-1)
        build(with: valueArray)
        self.size += 1
    }
    
    /**
     * Builds the tree from an array of values which are sorted according to their
     * rank.
     */
    private func build(with rankedArray: [Value]) {
        if self.root == nil {
            self.root = LadderNode<Value>(rank: 0, value: rankedArray[0])
        }
        self.root!.build(orderedValues: rankedArray)
    }
    
    
    public func search(rank: Int) -> LadderNode<Value>? {
        if let root = self.root {
            let resultNode = root.search(rank: rank)
            return resultNode
        }
        return nil
        
    }
    
    /// Rebalances the tree to keep tree traversals to a minimum.
    private func balance() {
        
    }
    
    
    /**
     * Returns an array of values sorted by their order.
     */
    public func inorderArray(rootNode: LadderNode<Value>?) -> [Value] {
        var nodeArray : [Value] = []
        if let node = rootNode {
            let rightTreeArray = inorderArray(rootNode: node.rightChild)
            nodeArray.append(contentsOf: rightTreeArray)
            nodeArray.append(node.value)
            let leftTreeArray = inorderArray(rootNode: node.leftChild)
            nodeArray.append(contentsOf: leftTreeArray)
        }
        return nodeArray
    }
    
}

public class LadderNode<Value> {
    
    fileprivate(set) public var rank : Int
    fileprivate(set) public var value : Value
    
    fileprivate(set) public var parent : LadderNode?
    fileprivate(set) public var leftChild : LadderNode?
    fileprivate(set) public var rightChild : LadderNode?
    
    public init(rank: Int, value : Value) {
        self.rank = rank
        self.value = value
    }
    
    /**
     Returns a node from the subtree of the calling node
     */
    fileprivate func search(rank: Int)-> LadderNode<Value>? {
        var node : LadderNode<Value>?
        
        // Searched node is ranked lower than current node.
        if rank > self.rank {
            if let lChild = self.leftChild {
                node = lChild.search(rank: rank)
                return node
            }
            else {
                return nil
            }
        }
            // Searched node is ranked higher than current node.
        else if rank < self.rank {
            if let rChild = self.rightChild {
                node = rChild.search(rank: rank)
                return node
            }
            else {
                return nil
            }
        }
            // Reached the node to be searched.
        else {
            return self
        }
        
    }
    
    fileprivate func insertNewValue(with rank: Int, value: Value) {
        // New value is ranked higher than current node rank.
        if rank < self.rank {
            if let rightChild = self.rightChild {
                rightChild.insertNewValue(with: rank, value: value)
            }
            else {
                let node = LadderNode<Value>(rank: rank, value: value)
                self.rightChild = node
            }
        }
            // New value is ranked lower than current node rank.
        else if rank > self.rank {
            if let leftChild = self.leftChild {
                leftChild.insertNewValue(with: rank, value: value)
            }
            else {
                let node = LadderNode<Value>(rank: rank, value: value)
                self.leftChild = node
            }
        }
            // Rank already exists.
        else {
            
        }
    }
    
    fileprivate func build(orderedValues : [Value]) {
        self.leftChild = nil
        self.rightChild = nil
        
        var rankedVals : [RankedValue] = []
        for index in 0...orderedValues.count-1 {
            let value = orderedValues[index]
            let rankedVal = RankedValue(rank: index+1, value: value)
            rankedVals.append(rankedVal)
        }
        self.recursiveBuild(rankedValues: rankedVals)
    }
    
    private func recursiveBuild(rankedValues: [RankedValue]) {
        let midPoint = rankedValues.count/2
        let value = rankedValues[midPoint]
        self.rank = value.rank
        self.value = value.value
        
        let rightChildArray = Array(rankedValues[..<midPoint])
        let leftChildArray = Array(rankedValues[(midPoint+1)...])
        
        
        if rightChildArray.count > 0 {
            self.rightChild = LadderNode(rank: 0, value: rightChildArray[0].value)
            self.rightChild?.parent = self
            self.rightChild?.recursiveBuild(rankedValues: rightChildArray)
        }
        if leftChildArray.count > 0 {
            
            self.leftChild = LadderNode(rank: 0, value: leftChildArray[0].value)
            self.leftChild?.parent = self
            self.leftChild?.recursiveBuild(rankedValues: leftChildArray)
        }
    }
    
    public func lowestRanked()-> LadderNode? {
        return leftChild?.lowestRanked() ?? self
    }
    
    public func highestRanked()-> LadderNode? {
        return rightChild?.highestRanked() ?? self
    }
    
    fileprivate struct RankedValue {
        var rank : Int
        var value : Value
    }
    
}


