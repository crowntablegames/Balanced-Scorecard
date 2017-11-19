//
//  NetworkManager.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 7/8/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import Foundation
import UserNotifications

class NetworkManager {
    
    static public var shared = NetworkManager()
    private init() {
        
    }
    
    public func getData(from urlPath: String, completion: @escaping (_ data: Data?, _ error:  Error?) -> Void) {
        
        let url = URL(string: urlPath)!
        
        let task = URLSession.shared.dataTask(with: url) {data, response, error in
            if error != nil {
                print(error.debugDescription)
            }
            else {
                completion(data, nil)
                
            }
        }
        task.resume()
    }
    
    public func post(jsonObject : NSDictionary, toURLPath : String,  completion: @escaping (_ data : Data?, _ error : Error?) -> Void) {
        let url: URL = URL(string: toURLPath)!
        var request : URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
            request.httpBody = data
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in

                if error != nil {
                    print("Download Error")
                    print(error!.localizedDescription)
                    completion(nil, error)
                    
                }
                else {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as! NSArray
                        print("JSOOOOOOn")
                        print(json)
                    }
                    catch {
                        print("Json ERrrrooorr")
                       print(error.localizedDescription)
                    }
                    DispatchQueue.main.async(execute: {
                        completion(data, nil)
                        
                    })
                }

            }
            task.resume()
        }
        catch let error {
            
            print(error.localizedDescription)
        }
        
    }
    
    public func post(data: Data, toURLPath : String,  completion: @escaping (_ data : Data?, _ error : Error?) -> Void) {
        let url: URL = URL(string: toURLPath)!
        var request : URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = data
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
            if error != nil {
                print("Download Error")
                print(error!.localizedDescription)
                completion(nil, error)
                    
            }
            else {
                DispatchQueue.main.async(execute: {
                    completion(data, nil)
                        
                })
            }
                
        }
        task.resume()
    }
    
    
    public func auth(url: String, username: String, password: String, completion: @escaping (_ successful: Bool) -> Void) {
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        let loginString = "\(username):\(password)"
        let loginData = loginString.data(using: String.Encoding.utf8)!
        
        request.setValue("Basic \(loginData.base64EncodedString())", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    completion(false)
                }
                else {
                    completion(true)
                }
            }
            
        }.resume()
        
        
    }
    
    

}
