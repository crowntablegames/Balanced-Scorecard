//
//  NearbyDealersViewController.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 30/6/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import UIKit


class NearbyDealersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddDealerDelegate {
//    let dealerDatabase = DealerDatabaseModel(databaseQueryPath: "http://titan.csit.rmit.edu.au/~s3459784/DatabaseTesting/dealerDatabase.php")
    var tables : [Table] = []
    
    @IBOutlet weak var nearbyDealerTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.downloadNearbyTables()
        self.setupTableView()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
    }
    
    private func downloadNearbyTables() {
        
        let selectQuery : SelectQuery = {
            
            let fields = [Field.init(fieldName: "*", fieldValue: "")]
            
            let join = Join.init(joinTableName: "Dealer", joinTableValue: "dealerID", relatedTableName: "Table", relatedTableValue: "dealer", clauseType: .inner, clauseOperator: .equal)
            let join2 = Join.init(joinTableName: "GameType", joinTableValue: "id", relatedTableName: "Table", relatedTableValue: "gameType", clauseType: .inner, clauseOperator: .equal)
            
            let jClause = JoinClause(joins: [join, join2])
            
            return SelectQuery(fields: fields, tableName: "`Table`", distinctResults: false, whereClause: nil, joinClause: jClause)
        }()
        
        do {
            let dictionary : NSDictionary = try ["query" : selectQuery.asString()]
            NetworkManager.shared.post(jsonObject: dictionary, toURLPath: "http://saturn.csit.rmit.edu.au/~s3459784/DatabaseTesting/dealerDatabase.php") {
                data, error in
               
                if data != nil {
                    do {
                        let jsonArray = try JSONSerialization.jsonObject(with: data!, options: []) as! NSArray
                        
                        for tableDictionary in jsonArray {
                            let table = Table(tableDictionary: tableDictionary as! NSDictionary)
                            self.tables.append(table)
                            self.nearbyDealerTable.reloadData()
                        }
                    }
                    catch let er {
                        print("JSON Error")
                        print(er.localizedDescription)
                    }
                
                }
            }
            
        }
        catch let error {
            print("Download Error")
            print(error.localizedDescription)
        }
        
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View Methods
    
    private func setupTableView() {
        
        //Set the delegate and data source
        self.nearbyDealerTable.dataSource = self
        self.nearbyDealerTable.delegate = self
        
        //Modify appearance
        self.nearbyDealerTable.backgroundColor = UIColor.black
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        //let vc = sb.instantiateViewController(withIdentifier: "assessmentPageVC") as! AssessmentPageViewController
        let vc = sb.instantiateViewController(withIdentifier: "assessmentVC") as! AssessmentViewController
        vc.assessedDealer = tables[indexPath.row].dealer!
        
        for _ in 0...2 {
            var comparisonTableIndex : Int!
            repeat {
                comparisonTableIndex = Int(arc4random_uniform(UInt32(tables.count)))
            } while (comparisonTableIndex == indexPath.row)
            
                vc.comparisonDealers.append(self.tables[comparisonTableIndex].dealer!)
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tables.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dealerCell")!
        cell.backgroundColor = UIColor.black
        cell.textLabel?.textColor = UIColor.white
        let table = self.tables[indexPath.row]
        cell.textLabel?.text = "\(table.toString()) \(table.dealer!.toString())"
        return cell
    }
    
    // MARK: - Other Methods

    // MARK: - Navigation Methods

    @objc private func pushAddDealerViewController() {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addDealerVC") as! AddDealerViewController
        
            vc.delegate = self
        //let nav = AddDealerNavigationViewController(rootViewController: vc)
        self.present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Dealer Database Delegate Methods

    func dealerAdded(dealer: Dealer) {
        
    }
 
}
