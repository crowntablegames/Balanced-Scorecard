//
//  DealerDatabase.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 10/7/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import Foundation

protocol DealerDatabaseDelegate {
    func didFinishDownloadingData(word : String)
}

class DealerDatabaseModel : NSObject, URLSessionDataDelegate {
    
    var dealers : [Dealer] = []
    var delegate : DealerDatabaseDelegate?
    
    init(databaseQueryPath: String) {
        super.init()
        self.urlPath = databaseQueryPath
        
    }
    
    var urlPath : String!
    
    public func performDatabaseQuery(databaseQuery : DealerDatabaseQuery, completion: @escaping (_ : String)->Void) {
        
        let url: URL = URL(string: urlPath)!
        var request : URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let queryDictionary = databaseQuery.createQueryDictionary()
            else { print("Query Dictionary Not Successfully Created")
                return
        }
        
        //print(queryDictionary)
        let data = try? JSONSerialization.data(withJSONObject: queryDictionary, options: .prettyPrinted)
        
        
        request.httpBody = data
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
                        
            if(error != nil) {
                print(error.debugDescription)
            }
            
            if(databaseQuery.getQueryType() == .select) {
                print("Passing JSON")
                self.parseJSON(data!)

            }
            DispatchQueue.main.async(execute: {
                print("Complete Database Query");
                let postTypeString = queryDictionary["queryType"] as! String
                completion(postTypeString)

            })
            
        }
        task.resume()
    }

    
    func parseJSON(_ data:Data) {
        
        var jsonResult = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            
            
        } catch let error as NSError {
            print("Error: \(error)")
            
        }
        print(jsonResult)
        var dealerDictionary = NSDictionary()
        
        for i in 0 ..< jsonResult.count
        {
            dealerDictionary = jsonResult[i] as! NSDictionary
            
            let dealer = Dealer(dealerDictionary: dealerDictionary)
            if dealer != nil {
                dealers.append(dealer!)
            }
        }
        
        
        

    }
}



