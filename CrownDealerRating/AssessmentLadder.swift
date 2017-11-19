//
//  AssessmentLadder.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 9/11/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import Foundation

class AssessmentLadder {
    
    /// ID number of the assessor
    private(set) public var assessor : Employee!
    
    /// Type of assessment being completed
    private(set) public var assessmentType: AssessmentType!
    
    /// The ladder that manages the rankings of an employee for a given assessment type.
    private(set) public var ladder : BSTLadder<Int>?
    private let downloadURLString = "http://18.221.45.138/ladder.php"
    
    public var maximumRequiredComparisons : Int {
        return Int(log2(Double(self.ladder!.size))) + 1
    }
    public init(assessorID : Int, assessmentTypeID: Int) {
        initialiseAssessmentLadder(assessorID: assessorID, assessmentTypeID: assessmentTypeID)
    }
    
    public func completeAssessment(for employee : Int) {
    
    }
    
    /// Downloads and converts JSON to Assessment Ladder
    private func initialiseAssessmentLadder(assessorID : Int, assessmentTypeID: Int) {
        let urlString = "\(self.downloadURLString)?id=\(assessorID)&type=\(assessmentTypeID)"
        print("\(urlString)")
        let sem = DispatchSemaphore(value: 0)
        NetworkManager.shared.getData(from: urlString, completion: {data, er in
            if er != nil {
                print("Error Exists")
                sem.signal()
            }
            else {
                // TODO: Convert JSON from webpage to Assessment Ladder
                do {
                    print("Assessment Ladder Json")
                    let json = try JSONSerialization.jsonObject(with: data!, options: [.mutableContainers]) as! NSDictionary
                    
                    let assessorDictionary = json["assessor"] as! NSDictionary
                    self.assessor = Employee(with: assessorDictionary)
                    let assessmentTypeDictionary = json["assessmentType"] as! NSDictionary
                    self.assessmentType = AssessmentType(with: assessmentTypeDictionary)
                    let orderedNodes = json["orderedNodes"] as! [Int]
                    self.ladder = BSTLadder<Int>(rankedArray: orderedNodes)
                }
                catch {
                    print(error.localizedDescription)
                }
                sem.signal()
            }
        })
        sem.wait()
    }
    
    public struct Employee : Decodable {
        var id : Int
        var firstName : String
        var lastName : String
        var area: String
        var photoURL: String
        
        init(with dictionary: NSDictionary) {
            id = dictionary["id"] as! Int
            firstName = dictionary["firstName"] as! String
            lastName = dictionary["lastName"] as! String
            area = dictionary["area"] as! String
            photoURL = dictionary["photoURL"] as! String
        }
        
    }
    
    public struct AssessmentType : Decodable {
        
        private(set) var id : Int
        private(set) var type : String
        private(set) var group : String
        
        init(with dictionary: NSDictionary) {
            id = dictionary["id"] as! Int
            type = dictionary["type"] as! String
            group = dictionary["group"] as! String
        }
        
    }
    
}
