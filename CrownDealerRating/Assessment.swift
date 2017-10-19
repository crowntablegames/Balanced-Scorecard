//
//  Assessment.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 2/7/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import Foundation

public class Assessment {
    
    var assessmentType : AssessmentManager.AssessmentType!
    var greaterDealer : Dealer?
    var improvementDealer : Dealer?
    
    init(greaterDealer : Dealer, improvementDealer : Dealer, assessmentType : AssessmentManager.AssessmentType) {
        self.greaterDealer = greaterDealer
        self.improvementDealer = improvementDealer
        self.assessmentType = assessmentType
    }
    
    init(assessmentType: AssessmentManager.AssessmentType) {
        self.assessmentType = assessmentType
    }
    
    
    public func asDictionary() -> NSDictionary? {
    
        let assessmentDictionary : NSDictionary = ["greaterDealer": greaterDealer!.asDictionary(), "improvementDealer" : improvementDealer!.asDictionary(), "assessmentType" : assessmentType.asDictionary()]
        
        
        return assessmentDictionary
    }
    
    
    func setAssessmentDealers(greaterDealer : Dealer, improvementDealer : Dealer) -> Bool {
        if self.greaterDealer == nil {
            self.greaterDealer = greaterDealer
            self.improvementDealer = improvementDealer
            return true
        }
        
        return false
        
    }
    
    func swapGreaterDealer() {
        let tempDealer = self.greaterDealer
        self.greaterDealer = self.improvementDealer
        self.improvementDealer = tempDealer
    }
    
    
    
    
}
