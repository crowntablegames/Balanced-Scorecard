//
//  MainSplitViewController.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 30/7/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import UIKit

class MainSplitViewController: UISplitViewController, MasterViewDelegate {
    
    var detailViewControllers : [UIViewController] {
         let controller1 = getViewControllerBy(indentifier: "dealerListNavVC")
         let controller3 = getViewControllerBy(indentifier: "assessmentNavController")
        return [controller1, controller3]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        let vc = self.viewControllers.first?.childViewControllers.first as! MasterViewController
        vc.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getViewControllerBy(indentifier : String) -> UIViewController {
        
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: indentifier)
    }
    
    func tableItemSelected(indexPath: IndexPath) {
        self.showDetailViewController(detailViewControllers[indexPath.row], sender: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
