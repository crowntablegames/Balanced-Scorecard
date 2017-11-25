//
//  AssessmentLadderViewController.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 14/11/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import UIKit

protocol AssessmentLadderViewDelegate {
    func ladderUpdated()
    func assessmentCancelled()
}
class AssessmentLadderViewController: UIViewController {
    
    @IBOutlet weak var ladderDealerImage: UIButton!
    @IBOutlet weak var assessedDealerImage: UIButton!
    @IBOutlet weak var assessmentDescriptionLabel: UILabel!
    @IBOutlet weak var requiredAssessmentsLabel: UILabel!
    @IBOutlet weak var undoButton: UIBarButtonItem!
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    public var delegate : AssessmentLadderViewDelegate?
    var assessedEmployee: AssessmentLadder.Employee!
    var assessmentType: AssessmentLadder.AssessmentType!
    var ladder: AssessmentLadder?
    private var currentNode : LadderNode<Int>?
    private var employeeURLString = "http://18.221.45.138/employees.php"
    private var ladderURLString = "http://18.221.45.138/postladder.php"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.undoButton.isEnabled = false
        self.ladder = AssessmentLadder(assessorID: appDelegate.user.id, assessmentTypeID: assessmentType.id)
        let ar = ladder?.ladder?.inorderArray(rootNode: self.ladder?.ladder?.root)
        for val in ar! {
            print(val)
        }
        downloadAssessorImage()
        self.currentNode = self.ladder?.ladder?.root
        if setCurrentRootNode() {
            downloadEmployee(from: self.currentNode!.value)
            setupLabels()
        }
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        if self.currentNode == nil {
            self.ladder?.ladder?.insert(at: 1, value: self.assessedEmployee.id)
            presentAlert(alertMessage: "No previous assessed employees to compare against. \(self.assessedEmployee.id) has been added.")
        }
        
    }
    // MARK: - IBActions
    @IBAction func cancelAssessment() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func undo() {
        print("Current Node Value: \(self.currentNode!.value)")
        if let parent = self.currentNode?.parent {
            print("Parent Value: \(parent.value)")
            self.currentNode = parent
            self.downloadEmployee(from: parent.value)
            self.updateUndoButton()
        }
        else {
            print("No Parent")
        }
    }
    
    private func updateUndoButton() {
        if self.currentNode?.parent != nil {
            self.undoButton.isEnabled = true
        }
        else {
            self.undoButton.isEnabled = false
        }
    }
    
    private func updateLadder(completion: @escaping () ->Void) {
        // TODO - Write code that sends the new ordered node list to the database.
        print("Ladder is \(self.ladder?.ladder)")
        let root = self.ladder?.ladder?.root
        print("Rooooot is \(root)")
        let orderedEmployeeArray = self.ladder?.ladder?.inorderArray(rootNode: root)
        let assessor = self.appDelegate.user
        let assessmentDictionary : NSDictionary = ["assessor": assessor!.id, "assessmentType" : self.assessmentType.id, "rankedEmployees": orderedEmployeeArray ?? []]
        
        print(assessmentDictionary)
        NetworkManager.shared.post(jsonObject: assessmentDictionary, toURLPath: self.ladderURLString, completion: {data, error in
            if error == nil {
                print("Error Is Nil")
                completion()
            }
            else {
                print("Signalling Semaphore")
                completion()
            }

        })
        
    }
    
    /// Pressed when the employee being assessed is greater at the assessment type than the comparison dealer.
    @IBAction func assesedEmployeeButtonPressed() {
        if let rightChild = self.currentNode?.rightChild {
            self.currentNode = rightChild
            self.downloadEmployee(from: rightChild.value)
            self.updateUndoButton()

        }
        else {
            var rank = self.currentNode!.rank
            print("Rank Before Update \(rank)")
            if rank < 1 {
                rank = 1
            }
            print("Rank After Update \(rank)")
            // Inserts the assessed employee at the ranking 1 position below the current rank.
            self.ladder?.ladder?.insert(at: rank, value: self.assessedEmployee.id)
            self.confirmAlert()
        }
    }
    
    /// Pressed when the comparison employee is greater at the given assessment type than the employee being asssessed.
    @IBAction func comparisonEmployeeButtonPressed() {
        if let leftChild = self.currentNode?.leftChild {
            self.currentNode = leftChild
            self.downloadEmployee(from: leftChild.value)
            self.updateUndoButton()

        }
        else {
            let rank = self.currentNode!.rank + 1
            print("Current Node Comparison Rank \(rank)")

            // Inserts the assessed employee at the ranking 1 position below the current rank.
            self.ladder?.ladder?.insert(at: rank, value: self.assessedEmployee.id)
            self.confirmAlert()
        }
    }
 
    private func setupButtons() {
        self.ladderDealerImage.layer.cornerRadius = self.ladderDealerImage.frame.width/2
        self.assessedDealerImage.layer.cornerRadius = self.ladderDealerImage.frame.width/2
    }
   
    override func viewWillLayoutSubviews() {
        setupButtons()
    }
   
    private func downloadAssessorImage() {
        NetworkManager.shared.getData(from: self.assessedEmployee.photoURL, completion: {data, error in
            print("Assessed Dealer Image Download")
            let image = UIImage(data: data!)
            DispatchQueue.main.async {
                self.assessedDealerImage.setImage(image, for: .normal)
                print("Assessed Main Sync")
            }
        })
    }
    
    private func downloadEmployee(from id: Int) {
        let urlString = "\(self.employeeURLString)?empID=\(id)"
        var employee : AssessmentLadder.Employee!
        let sem = DispatchSemaphore(value: 0)
        NetworkManager.shared.getData(from: urlString, completion: {data, error in
            do {
                employee = try JSONDecoder().decode(AssessmentLadder.Employee.self, from: data!)
                sem.signal()
            }
            catch {
               print(error.localizedDescription)
            }
        })
        sem.wait()
        
        NetworkManager.shared.getData(from: employee.photoURL, completion: {data, error in
           
            let image = UIImage(data: data!)
            DispatchQueue.main.async {
                self.ladderDealerImage.setImage(image, for: .normal)
            }
        })
    }
    
    private func setupLabels() {
        self.requiredAssessmentsLabel.text = "Max Required Assessments To Complete: \(self.ladder!.maximumRequiredComparisons)"
        self.assessmentDescriptionLabel.text = "\(self.assessmentType.type)"
    }
    
    private func setCurrentRootNode() -> Bool {
        if let node = self.ladder?.ladder?.root {
            self.currentNode = node
            return true
        }
        else {
            return false
        }
    }
    
    func presentAlert(alertMessage: String) {
        let alertController = UIAlertController(title: nil, message: alertMessage, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in
            self.dismissScreen()
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true) {
            print("Presenting Alert View Controller")
            // ...
        }
    }
    
    func confirmAlert() {
        let alertController = UIAlertController(title: nil, message: "Confirm Assessment Submission", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "Confirm", style: .default) { action in
            self.presentAlert(alertMessage: "Successfully Assessed \(self.assessedEmployee.id)")
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
            
        }
        alertController.addAction(OKAction)
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true) {
            print("Presenting Alert View Controller")
            // ...
        }
    }
    private func dismissScreen() {
        self.updateLadder(completion: {
            print("Updated Ladder")
        })
        print("Dismissing")
        self.dismiss(animated: true, completion: {
            print("Ladder Delegate Updated")
            self.delegate?.ladderUpdated()
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
