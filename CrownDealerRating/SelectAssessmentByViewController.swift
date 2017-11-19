//
//  SelectAssessmentByViewController.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 13/11/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import UIKit

class SelectAssessmentByViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView : UITableView!
    
    let cellTitleArray : [String] = ["Employee", "Assessment Type"]
    let cellID = "selectByCell"
    let employeeSegueID = "employeeTableSegue"
    let aTypeSegueID = "assessmentTypeTableSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Choose Assessment From"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellTitleArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)!
        cell.textLabel!.text = self.cellTitleArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: employeeSegueID, sender: indexPath.row)
        case 1:
            performSegue(withIdentifier: aTypeSegueID, sender: indexPath.row)
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == employeeSegueID {
            let dest = segue.destination as! EmployeeTableViewController
            
        }
        else if segue.identifier == aTypeSegueID {
            let dest = segue.destination as! AssessmentTypeTableViewController
            dest.downloadAllAssessmentTypes()
        }
    }
    

}
