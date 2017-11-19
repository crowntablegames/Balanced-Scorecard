//
//  EmployeeTableViewController.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 13/11/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import UIKit

class EmployeeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
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
        UIApplication.shared.beginIgnoringInteractionEvents()
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
            downloadImageFrom(url: emp.photoURL)
        }
        UIApplication.shared.endIgnoringInteractionEvents()
        self.tableView.reloadData()
    }
    
    func updateRequiredEmployees() {
        let user = self.delegate.user
        let urlString = "\(self.employeeURLString)?userID=\(user!.id)"
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
            downloadImageFrom(url: emp.photoURL)
        }
        UIApplication.shared.endIgnoringInteractionEvents()
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
            dest.assessedEmployee = self.employeeArray[row]
            dest.assessmentType = self.assessmentType
        }
        
        
    }
    

}
