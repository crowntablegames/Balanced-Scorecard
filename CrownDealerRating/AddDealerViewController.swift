//
//  AddDealerViewController.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 14/7/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import UIKit

protocol AddDealerDelegate {
    func dealerAdded(dealer : Dealer)
}

class AddDealerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SubmitCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    let cellLabels : [String] = ["First Name", "Surname", "ID"]
    
    var delegate : AddDealerDelegate?
    
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row <
            tableView.numberOfRows(inSection: 0) - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dealerInfoCell") as! DealerInfoTableViewCell
            cell.label.text = cellLabels[indexPath.row]
            return cell

        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "submitCell") as! SubmitTableViewCell
            cell.delegate = self
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func submitButtonPressed() {
        
        var firstName : String?
        var lastName : String?
        var id : NSNumber?
        
        for index in 0...2 {
            let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! DealerInfoTableViewCell
            
            switch index {
            case 0:
                firstName = cell.textField.text
            case 1:
                lastName = cell.textField.text
            case 2:
                let text = cell.textField.text
                if let myInteger = Int(text!) {
                     id = NSNumber(value:myInteger)
                }

            default:
                print()
            }
            
        }
        
        let dealer = Dealer(firstName: firstName!, secondName: lastName!, id: id!)

        self.delegate?.dealerAdded(dealer: dealer)
        self.dismiss(animated: true, completion: nil)
    }   /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
