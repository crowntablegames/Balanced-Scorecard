//
//  EmployeeTableViewController.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 13/11/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import UIKit

class EmployeeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AssessmentLadderViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator : UIActivityIndicatorView!
    @IBOutlet weak var emptyLabel : UILabel!
    
    let cellID = "userCell"
    let employeeURLString = "http://18.221.45.138/employees.php"
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var employeeArray : [AssessmentLadder.Employee] = []
    var employeeImages : [UIImage] = []
    var assessmentType : AssessmentLadder.AssessmentType?

//    private var selectedEmployee : AssessmentLadder.Employee?
    
    private var reqTypeSegueID = "dealerRequiredTypeSegue"
    private var assessmentSegueID = "assessmentSegue"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        self.updateEmployeeList()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.employeeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! EmployeeTableViewCell
        let employee = self.employeeArray[indexPath.row]
        cell.update(with: employee, and: self.employeeImages[indexPath.row])
        print(employee.firstName)
        return cell
    }
    
    func updateEmployeeList() {
        let user = self.delegate.user
        var urlString = "\(self.employeeURLString)?userID=\(user!.id)"
        if self.assessmentType != nil {
            urlString = "\(urlString)&type=\(self.assessmentType!.id)"
        }
        let queue = DispatchQueue(label: "Download Queue")
        queue.async {
            DispatchQueue.main.async {
                UIApplication.shared.beginIgnoringInteractionEvents()
                self.activityIndicator.startAnimating()
            }
            let sem = DispatchSemaphore(value: 0)
            
            NetworkManager.shared.getData(from: urlString, completion: {data, error in
                do {
                    self.employeeArray = try JSONDecoder().decode([AssessmentLadder.Employee].self, from: data!)
                    sem.signal()
                }
                catch {
                    print(error.localizedDescription)
                    sem.signal()
                }
                
            })
            sem.wait()
            self.employeeImages = []

            for emp in self.employeeArray {
                self.downloadImageFrom(url: emp.photoURL)
            }
            
            DispatchQueue.main.async {
                if self.employeeArray.count == 0 {
                    print("Employee Count For Animation is 0")
                    self.emptyLabel.isHidden = false
                    self.emptyLabel.alpha = 1
                    
                }
                else {
                    self.emptyLabel.alpha = 0
                    
                }
                UIApplication.shared.endIgnoringInteractionEvents()
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
        
    }
    
    func updateRequiredEmployees() {
        print("Updating Required Only")
        let user = self.delegate.user
        let urlString = "\(self.employeeURLString)?userID=\(user!.id)"
        let queue = DispatchQueue(label: "Download Queue")
        queue.async {
            DispatchQueue.main.async {
                UIApplication.shared.beginIgnoringInteractionEvents()
                self.activityIndicator.startAnimating()
            }
            let sem = DispatchSemaphore(value: 0)
            NetworkManager.shared.getData(from: urlString, completion: {data, error in
                do {
                    self.employeeArray = try JSONDecoder().decode([AssessmentLadder.Employee].self, from: data!)
                    sem.signal()
                }
                catch {
                    print(error.localizedDescription)
                    sem.signal()
                }
                
            })
            sem.wait()
            
            for emp in self.employeeArray {
                queue.sync {
                    self.downloadImageFrom(url: emp.photoURL)
                    sem.signal()
                }
                sem.wait()
            }
            
            DispatchQueue.main.async {
                UIApplication.shared.endIgnoringInteractionEvents()
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    private func downloadImageFrom(url: String) {
        let sem = DispatchSemaphore(value: 0)
        NetworkManager.shared.getData(from: url, completion: {data, error in
            if let image = UIImage(data: data!) {
                
                    self.employeeImages.append(image)
            }
            sem.signal()
        })
        sem.wait()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //self.selectedEmployee = self.employeeArray[indexPath.row]
        if (self.assessmentType == nil) {
            performSegue(withIdentifier: reqTypeSegueID, sender: indexPath.row)
        }
        else {
            performSegue(withIdentifier: self.assessmentSegueID, sender: indexPath.row)

        }
        tableView.deselectRow(at: indexPath, animated: true)

    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let row = sender as! Int

        if segue.identifier == self.reqTypeSegueID {
            let dest = segue.destination as! AssessmentTypeTableViewController
            let employee = self.employeeArray[row]
            print("Employee Segue")
            print(employee)
            dest.downloadRemainingAssessmentTypes(for: employee)
        }
        else {
            let dest = segue.destination as! AssessmentLadderViewController
            dest.delegate = self
            dest.assessedEmployee = self.employeeArray[row]
            dest.assessmentType = self.assessmentType
        }
       
    }
    
    // MARK : - Assessment Ladder Delegate
    func ladderUpdated() {
        self.updateEmployeeList()
        
        //self.navigationController?.popToRootViewController(animated: true)
    }
    
    func assessmentCancelled() {
        self.updateEmployeeList()
    }
    

}
