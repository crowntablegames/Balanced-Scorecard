//
//  MasterViewController.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 30/7/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import UIKit

protocol MasterViewDelegate {
    func tableItemSelected(indexPath: IndexPath)
}

class MasterViewController: UITableViewController {
    
    var delegate : MasterViewDelegate?
    
    let titles = ["Area Managers", "Tables"]
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionCell")!
        cell.backgroundColor = UIColor.darkGray
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text = titles[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.tableItemSelected(indexPath: indexPath)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Menu"
        self.view.backgroundColor = UIColor.black
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
