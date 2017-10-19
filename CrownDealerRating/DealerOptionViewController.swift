//
//  TableListViewController.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 31/7/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import UIKit

class DealerOptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableInfoTableView : UITableView!
    var cellTitles = ["Assess Dealer", "Assessment Results"]
    var dealer : Dealer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableInfoTableView.dataSource = self
        self.tableInfoTableView.delegate = self
        self.navigationItem.title = "\(self.dealer!.getFirstName()) \(self.dealer!.getSecondName())"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableInfoCell")!
        cell.textLabel?.text = cellTitles[indexPath.row]
        cell.detailTextLabel?.text = "detail is here"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
             let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "assessmentVC") as! AssessmentViewController
            vc.assessedDealer = self.dealer!

            for _ in 0...2 {
                var comparisonTableIndex : Int!
                repeat {
                    comparisonTableIndex = Int(arc4random_uniform(UInt32(DealerManager.shared.dealers.count)))
                } while (DealerManager.shared.dealers[comparisonTableIndex].getID() == self.dealer!.getID())
                
                vc.comparisonDealers.append(DealerManager.shared.dealers[comparisonTableIndex])
                
            }
            tableView.deselectRow(at: indexPath, animated: true)

            self.navigationController?.pushViewController(vc, animated: true)
            

        }
        else {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "assessmentResultsVC") as! RatingViewController
            vc.dealer = self.dealer
            tableView.deselectRow(at: indexPath, animated: true)
            vc.resultsDictionary = AssessmentManager.shared.resultsDictionariesFor(groups: AssessmentManager.shared.assessmentGroups, with: self.dealer!)
            self.navigationController?.pushViewController(vc, animated: true)

        }
        
    }
    

}
