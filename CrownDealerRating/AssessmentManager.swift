//
//  AssessmentManager.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 10/8/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import Foundation
import UserNotifications

public class AssessmentManager {
    
    public static var shared : AssessmentManager = AssessmentManager()
    private var serverURLString : String = "http://18.221.45.138/dealerDatabase.php"
    public var assessments : [Assessment] = []
    public var assessmentTypes : [AssessmentType] = []
    public private(set) var assessmentGroups : [String] = ["Managing Self", "Accountability", "Service", "Communication", "Teamwork"]
   
    init() {

    }
    
    /**
    Add a single assessment both to the internal database on the device as well as to the AWS database instance.
    */
    public func add(assessments : [Assessment], completion : @escaping ()-> Void) -> Bool {
        
        guard assessments.count > 0 else {return false }
        
        for assessment in assessments {
            guard assessment.greaterDealer != nil else {return false}
            guard assessment.improvementDealer != nil else {return false}
            guard assessment.greaterDealer!.getID() != assessment.improvementDealer!.getID() else {return false}
            
        }
        
        let queryString = "insert into Assessment (greaterDealer, improvementDealer, assessmentTypeID) values (\(assessments[0].greaterDealer!.getID()), \(assessments[0].improvementDealer!.getID()), \(assessments[0].assessmentType.id)), (\(assessments[1].greaterDealer!.getID()), \(assessments[1].improvementDealer!.getID()), \(assessments[1].assessmentType.id)), (\(assessments[2].greaterDealer!.getID()), \(assessments[2].improvementDealer!.getID()), \(assessments[2].assessmentType.id))"
        
        
        /**
         qDict description
        */
        let qDict : NSDictionary = ["query" : queryString]
        
        NetworkManager.post(jsonObject: qDict, toURLPath: self.serverURLString) {_ in 
            print(self.assessments.count)
            for assessment in assessments {
                self.assessments.append(assessment)
            }
            
            print(self.assessments.count)

            completion()
        }
        return true
    }
    
    
    /// Downloads all assessments.
    public func downloadAllAssessments(completion : @escaping (_ error : Error?) -> Void) {
        
        let assessmentTypePostDictionary : NSDictionary = ["query" : "select * from AssessmentType"]
        
        let sem = DispatchSemaphore(value: 0)
        
        print("first sem wait")

        NetworkManager.post(jsonObject: assessmentTypePostDictionary, toURLPath: self.serverURLString) { data, error in
            
            if error != nil {
                print("First Sem Error")
                completion(error)
                sem.signal()
                return
            }
            else {
                do {
                    self.assessmentTypes = []

                    let assessmentTypeDictionaryArray = try JSONSerialization.jsonObject(with: data!, options: []) as! NSArray
                    
                    for assessmentTypeDictionary  in assessmentTypeDictionaryArray {
                        
                        let assessmentType : AssessmentType = AssessmentType.init(assessmentTypeDictionary: assessmentTypeDictionary as! NSDictionary)
                        self.assessmentTypes.append(assessmentType)
                        
                    }
                    print(self.assessmentTypes.count/5)
                }
                catch let error {
                    print("Assessment Type Error")
                    print(error.localizedDescription)
                }
                sem.signal()

            }
            sem.wait()
            
            print("second sem wait")
            let queryDictionary : NSDictionary = ["query" : "select a1.greaterDealer, a1.improvementDealer, a1.assessmentTypeID, d1.firstName greaterDealerFirstName, d1.lastName greaterDealerLastName, d1.area greaterDealerArea, d2.firstName improvementDealerFirstName, d2.lastName improvementDealerLastName, d2.area improvementDealerArea from Assessment a1 left join Dealer d1 ON d1.dealerID = a1.greaterDealer left join Dealer d2 ON d2.dealerID = a1.improvementDealer"]
            
            NetworkManager.post(jsonObject: queryDictionary, toURLPath: self.serverURLString) { data, error in
                print("2nd Post")

                if error != nil {
                    print("Second Sem Error")

                    completion(error)
                    return
                }
                else {
                    do {
                        self.assessments = []

                        let assessmentDictionaryArray = try JSONSerialization.jsonObject(with: data!, options: []) as! NSArray
                        
                        for ad in assessmentDictionaryArray  {
                            
                            let assessmentDictionary = ad as! NSDictionary
                            
                            let greaterDealerID : NSNumber = NSNumber(value: Int(assessmentDictionary.value(forKey: "greaterDealer") as! String)!)
                            let greaterDealer = Dealer(firstName: assessmentDictionary.value(forKey: "greaterDealerFirstName") as! String, secondName: assessmentDictionary.value(forKey: "greaterDealerLastName") as! String, id: greaterDealerID)
                            
                            let improvementDealerID : NSNumber = NSNumber(value: Int(assessmentDictionary.value(forKey: "improvementDealer") as! String)!)
                            
                            let improvementDealer = Dealer(firstName: assessmentDictionary.value(forKey: "improvementDealerFirstName") as! String, secondName: assessmentDictionary.value(forKey: "improvementDealerLastName") as! String, id: improvementDealerID)
                            
                            var assessmentType : AssessmentType?
                            let assessmentTypeID : Int = Int(assessmentDictionary.value(forKey: "assessmentTypeID") as! String)!
                            
                            
                            for aType in self.assessmentTypes {
                                if aType.id == assessmentTypeID {
                                    assessmentType = aType
                                }
                            }
                            let assessment = Assessment(greaterDealer: greaterDealer, improvementDealer: improvementDealer, assessmentType: assessmentType!)
                            
                            self.assessments.append(assessment)
                            
                        }
                        print("2nd sem signal")
                        completion(nil)
                        
                    }
                    catch let error {
                        print("Assessment Error")
                        print(error.localizedDescription)
                    }
                }
            }
            print("after second sem wait")

        }
    }
    
    public func generateRandomAssessmentType() -> AssessmentType? {
        
        guard self.assessmentTypes.count > 0 else {return nil}
        
        var assessmentType : AssessmentType?
        
        let randIndex = Int(arc4random_uniform(UInt32(assessmentTypes.count/5)))
        assessmentType = self.assessmentTypes[randIndex]
        
        
        return assessmentType
    }
    
    func numberOfAssessmentsFor(dealer : Dealer) -> Int {
        var total = 0
        for assessment in assessments {
            if assessment.greaterDealer?.getID() == dealer.getID() || assessment.improvementDealer?.getID() == dealer.getID() {
                total += 1
            }
        }
        return total
    }
    
    private func scoreFor(dealer : Dealer, with assessmentType : AssessmentType) -> Float {
     
        var totalNumberOfAssessments : Float = 0
        var totalNumberOfWonAssessments : Float = 0
        
        for assessment in self.assessments {
            if assessment.assessmentType.id == assessmentType.id {
                if assessment.greaterDealer!.getID() == dealer.getID() || assessment.improvementDealer!.getID() == dealer.getID(){
                    
                    totalNumberOfAssessments = totalNumberOfAssessments + 1
                    
                }
                
                if assessment.greaterDealer!.getID() == dealer.getID() {
                    totalNumberOfWonAssessments = totalNumberOfWonAssessments + 1
                }
            }
            
        }
        
        
        if totalNumberOfAssessments == 0 {
            return 0
        }
        
        return totalNumberOfWonAssessments/totalNumberOfAssessments
    }
    
    func scoresFor(dealer : Dealer, with assessmentTypes : [AssessmentType]) -> [Float] {
        
        var scoreArray : [Float] = []
        
        for aType in assessmentTypes {
            let score = scoreFor(dealer: dealer, with: aType)
            scoreArray.append(score)
        }
        return scoreArray
    }
    
    
    func averageScoreFor(area : Area, with assessmentType : AssessmentType) -> Float {
        // TO DO
        
        let score = Float(arc4random_uniform(UInt32(100)))/100
        return 0.5
    }
    
    func averageScoresFor(area : Area, with assessmentTypes : [AssessmentType]) -> [Float] {
        // TO DO
        var scores : [Float] = []
        for assessmentType in assessmentTypes {
            let score = averageScoreFor(area: area, with: assessmentType)
            scores.append(score)
        }
        return scores
    }
    
    func resultsDictionariesFor(groups : [String], with dealer: Dealer) -> NSDictionary {
        
        var groupResultsArray : [NSDictionary] = []
        
        for group in groups {
            var resultDictionary : [String : Any] = [:]
            
            resultDictionary["group"] = group
            // Get the assessment types for a given group
            var groupAssessmentTypes : [NSDictionary] = []
            for assessmentType in assessmentTypes {
                if assessmentType.group == group {
                    groupAssessmentTypes.append(assessmentType.asDictionary())
                    
                }
            }
            
            resultDictionary["groupAssessmentTypes"] = groupAssessmentTypes
            
            // Calculate the assessment scores for a given dealer for a given group.
            var dealerAssessmentScores : [Float] = []
            var teamAssessmentScores : [Float] = []

            for assesmentType in groupAssessmentTypes {
                let dealerScore = scoreFor(dealer: dealer, with: AssessmentManager.AssessmentType.init(assessmentTypeDictionary: assesmentType))
                dealerAssessmentScores.append(dealerScore)
                
                let teamAverageScore = averageScoreFor(area: dealer.area!, with: AssessmentManager.AssessmentType.init(assessmentTypeDictionary: assesmentType))
                teamAssessmentScores.append(teamAverageScore)
                
            }
            resultDictionary["dealerAssessmentScores"] = dealerAssessmentScores
            resultDictionary["teamAssessmentScores"] = teamAssessmentScores
        
            groupResultsArray.append(resultDictionary as NSDictionary)
        }
        
        return ["dealer" : dealer, "groupResultsArray" : groupResultsArray]
    }
    
    func averageScoreForAllDealersFor(assessmentType : AssessmentType) -> Float {
        return 0
    }
    
    func numberOfAssessmentsFor(dealer : Dealer, with assessmentTypeGroup : String) -> Int {
        
        var assessmentCount = 0
        
        
        for aType in self.assessmentTypes {

            if aType.group == assessmentTypeGroup {
                assessmentCount += 1
            }
        }
        
        
        return assessmentCount
    }
    
    public struct AssessmentType {
        
        private(set) var id : Int
        private(set) var type : String
        private(set) var group : String
        
        init(assessmentTypeDictionary : NSDictionary) {
            
            self.id = Int(assessmentTypeDictionary.value(forKey: "id") as! String)!
            self.type = assessmentTypeDictionary.value(forKey: "type") as! String
            self.group = assessmentTypeDictionary.value(forKey: "group") as! String
        }
        
        func asDictionary() -> NSDictionary {
            let dictionary : NSDictionary = ["id": String(self.id), "type" : self.type, "group": self.group]
            return dictionary
        }
    }
    
    
}
