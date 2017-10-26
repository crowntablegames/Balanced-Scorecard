//: Playground - noun: a place where people can play

import UIKit


struct Card {
    var suitRank: String = "Ace of Spades"
    
}
var player1Card = Card()
var player2Card = player1Card
player1Card.suitRank = "Six of Diamonds"
print("\(player1Card.suitRank), \(player2Card.suitRank)")

protocol PersonProtocol {
    var firstName : String {get}
    var secondName : String {get}
    func getDescription() -> String
}


class SalesClerk : PersonProtocol {
    
    var firstName : String
    var secondName : String
    
    init(firstName : String, secondName: String) {
        self.firstName = firstName
        self.secondName = secondName
    }
    func getDescription() -> String {
        return "\(firstName) \(secondName)"
    }
}
