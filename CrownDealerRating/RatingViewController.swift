//
//  RatingViewController.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 30/6/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import UIKit
import JBChart

class RatingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AssessmentResultCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var dealer : Dealer!
    var resultsDictionary : NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.resultsDictionary = AssessmentManager.shared.resultsDictionariesFor(groups: AssessmentManager.shared.assessmentGroups, with: self.dealer)
        self.tableView.reloadData()
        print("View Loaded")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.resultsDictionary = AssessmentManager.shared.resultsDictionariesFor(groups: AssessmentManager.shared.assessmentGroups, with: self.dealer!)
        self.tableView.reloadData()
        print("View Appeared")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("View Will Appear")
    }
    
    override func viewDidLayoutSubviews() {
        self.navigationController!.title = "Assessment Results"
        print("Rating View layed out subviews")


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AssessmentManager.shared.assessmentGroups.count + 1
    }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let resultsDictionaryArray = self.resultsDictionary.value(forKey: "groupResultsArray") as! NSArray
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "resultsDealerInfoCell") as! ResultsDealerInfoTableViewCell
            cell.updateCellLabelsWith(dealer: self.dealer)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "assessmentResultGraphCell") as! AssessmentResultGraphTableViewCell
            
            print("Loading Results")
            cell.updateResultsFor(dealer: dealer, resultsDictionary: resultsDictionaryArray[indexPath.row-1] as! NSDictionary)
            //cell.assessmentGroup = AssessmentManager.shared.assessmentGroups[indexPath.row - 1]
            cell.delegate = self
            return cell

        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0 {
            return 300
        }
        
        return 500
    }
    
    func chartIsTouched() {
        self.tableView.isScrollEnabled = false
    }
    
    func chartIsUntouched() {
        self.tableView.isScrollEnabled = true   

    }
    
}
