//: Playground - noun: a place where people can play

import UIKit

let tree = AVLTree<Int, Int>()
tree.insert(key: 7, payload: 387851)
tree.insert(key: 8, payload: 387852)
tree.insert(key: 9, payload: 384752)
tree.insert(key: -1, payload: 289)

let root = tree.getRoot()
let lesser1 = root?.lesserNode()
let array = tree.inorderArray(node: root)


for node in array {
    print(node.payload!)
}

