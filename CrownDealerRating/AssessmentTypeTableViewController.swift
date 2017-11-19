//
//  AssessmentTypeTableViewController.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 14/11/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import UIKit

class AssessmentTypeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AssessmentLadderViewDelegate {
    
    var assessmentTypes: [AssessmentLadder.AssessmentType] = []
    var assessedEmployee: AssessmentLadder.Employee?
    
    var cellID = "userATypeCell"
    private var aTypeURLString = "http://18.221.45.138/ladder_req_emp_type.php"
    private var allATypeURLString = "http://18.221.45.138/ladderTypes.php"
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var assessmentSegueID = "assessmentSegue"
    private var requiredEmpSegueID = "assessmentReqEmployeeSegue"
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.assessedEmployee == nil {
            performSegue(withIdentifier: requiredEmpSegueID, sender: indexPath.row)
        }
        else {
            performSegue(withIdentifier: assessmentSegueID, sender: indexPath.row)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.assessmentTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)!
        let type = self.assessmentTypes[indexPath.row]
        cell.textLabel?.text = type.type
        return cell
    }
    
    func downloadRemainingAssessmentTypes(for employee: AssessmentLadder.Employee) {
        self.assessedEmployee = employee
        let assessor = self.appDelegate.user
        let urlString = "\(self.aTypeURLString)?assessor=\(assessor!.id)&assessee=\(employee.id)"
        
        NetworkManager.shared.getData(from: urlString, completion: { data, err in
            
            do {
               self.assessmentTypes = try JSONDecoder().decode([AssessmentLadder.AssessmentType].self, from: data!)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
        })
    }
    
    func downloadAllAssessmentTypes() {
        print("Downloading All Assessment Types")
        NetworkManager.shared.getData(from: self.allATypeURLString, completion: {data, error in
            do {
                self.assessmentTypes = try JSONDecoder().decode([AssessmentLadder.AssessmentType].self, from: data!)
            }
            catch {
                print(error.localizedDescription)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let row = sender as! Int

        if segue.identifier == self.assessmentSegueID {
            let dest = segue.destination as! AssessmentLadderViewController
            dest.assessedEmployee = self.assessedEmployee
            dest.assessmentType = self.assessmentTypes[row]
            dest.delegate = self
        }
        else if segue.identifier == self.requiredEmpSegueID {
            let dest = segue.destination as! EmployeeTableViewController
            dest.assessmentType = self.assessmentTypes[row]
        }
    }
    
    // MARK: - AssessmentLadderViewDelegate
    
    func ladderUpdated() {
        print("Ladder Updated From VC")
        self.navigationController?.popToRootViewController(animated: true)
    }
    func assessmentCancelled() {
        
    }

}
