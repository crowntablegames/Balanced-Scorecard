//
//  MainMenuViewController.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 13/11/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController, LoginDelegate, UITableViewDataSource, UITableViewDelegate {
    
    let tableViewCellTitles : [String] = ["My Profile", "Complete Assessment"]
    @IBOutlet weak var tableView: UITableView!
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    private let loginSegueIdentifier = "loginSegue"
    private let menuCellID = "menuCell"
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
    
    override func viewDidAppear(_ animated: Bool) {
        print("View Did Appear")
        if self.delegate.user == nil {
            performSegue(withIdentifier: self.loginSegueIdentifier, sender: nil)
        }
        else {
            
            
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == self.loginSegueIdentifier {
            print("Setting Up Delegate")
            let dest = segue.destination as! LoginViewController
            dest.loginDelegate = self
        }
    }
    
    func successfulLogin() {
        if let user = self.delegate.user {
            print("Successful Login In VC")
            print(self.navigationController ?? "Nav Is Nil")
            self.navigationItem.title = "Logged In As: \(user.firstName) (\(user.id))"
            
        }
    }
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewCellTitles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.menuCellID)
        cell?.textLabel?.text = self.tableViewCellTitles[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            break
        case 1:
            push(to: "completeAssessmentSegue")
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    private func push(to segueID: String) {
        performSegue(withIdentifier: segueID, sender: nil)
    }

}
