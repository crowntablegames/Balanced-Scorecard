//
//  AssessmentPageViewController.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 2/7/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import UIKit

class AssessmentPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // MARK: - Variables
    
    //The table object that belongs to the dealer who was selected to be assessed
    var assessedDealerTable : Table!
    
    //An array of Table objects that contain dealers who will be compared to the assessedDealer.
    var comparisonDealerTables : [Table] = []
    
    //Array of the AssessmentViewControllers being used in the PageViewController
    lazy var VControllerArray : [AssessmentViewController] = {
       
        return [self.VControllerInstance(name: "assessmentVC"), self.VControllerInstance(name: "assessmentVC"), self.VControllerInstance(name: "assessmentVC")]
    }() as! [AssessmentViewController]
    
    // MARK: - View Controller Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        //Prepare the assessments to be passed to the view controllers
        
        if let firstVC = VControllerArray.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
   
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {

    }
    
    // MARK: - PageViewController Methods

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        let pvc = pageViewController as! AssessmentPageViewController
        
        return  pvc.VControllerArray.count
        
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = VControllerArray.index(of: viewController as! AssessmentViewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return VControllerArray.last
        }
        guard VControllerArray.count > previousIndex else {
            return nil
        }
        return VControllerArray[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = VControllerArray.index(of: viewController as! AssessmentViewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < VControllerArray.count else {
            return VControllerArray.first
        }
        guard VControllerArray.count > nextIndex else {
            return nil
        }
        return VControllerArray[nextIndex]
        
    }

    // MARK: - Other Methods
    
    //Returns an instance of a UIViewController that has been drawn up using Storyboard.
    private func VControllerInstance(name: String) -> UIViewController {
        
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name) as! AssessmentViewController
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
