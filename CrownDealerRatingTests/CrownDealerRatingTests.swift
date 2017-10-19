//
//  CrownDealerRatingTests.swift
//  CrownDealerRatingTests
//
//  Created by Campbell Brobbel on 30/6/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import XCTest

@testable import CrownDealerRating


class CrownDealerRatingTests: XCTestCase {
    
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDealers() {
        
    }
    
    func testExample() {
        
        let exp = expectation(description: "Ex")
        
        let jsonPost : NSDictionary = ["query" : "SELECT  * FROM `Table` JOIN Dealer ON Dealer.dealerID = Table.dealer JOIN GameType ON GameType.`id` = Table.gameType"]
        NetworkManager.post(jsonObject: jsonPost, toURLPath: "http://titan.csit.rmit.edu.au/~s3459784/DatabaseTesting/dealerDatabase.php") {
            
            data in
            
            if data != nil {
            
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data!, options: []) as! NSArray
                    
                    let tables = Table.tablesFrom(tableDictionaryArray: jsonObject)
                    print(tables)
                    for table in tables {
                        print(table.toString())
                    }
                    exp.fulfill()
                    
                }
                catch let error {
                    print(error.localizedDescription)
                }
            }
            else {
                print("Data was nil")
            }
        }
        
        waitForExpectations(timeout: 20, handler: nil)
        
    }
    
    func testAssessmentManager() {
        
        let exp = expectation(description:"e")
//        AssessmentManager.shared.downloadAllAssessments() {
//            print(AssessmentManager.shared.assessments[0].greaterDealer!.toString())
//            exp.fulfill()
//            let dealer = Dealer(firstName: "Campbell", secondName: "Brobbel", id: 387851)
//            
//            print(" Score \(AssessmentManager.shared.scoreFor(dealer: dealer, with: Assessment.AssessmentType.grooming))")
//            
//        }
        
        let urlString = "https://s3-ap-southeast-2.amazonaws.com/crown-area-manager-photos/3843.jpg"
        
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        
        URLSession.shared.dataTask(with: url!) {data, response, error in
            
            let image = UIImage(data: data!)
            print(image ?? "image is nil")
            exp.fulfill()
        }.resume()
        
        waitForExpectations(timeout: 20, handler: nil)
    }
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
