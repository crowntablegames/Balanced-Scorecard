//
//  DealerListViewController.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 9/8/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import UIKit

class DealerListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DelegateNotifier {
    
    
    @IBOutlet weak var dealerTableView : UITableView!
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBAction func refreshAssessments() {
        startActivityIndicator()
        DealerManager.shared.downloadAllDealers()
        
        AssessmentManager.shared.downloadAllAssessments { error in
            print("Stop Indicator")
            DispatchQueue.main.async {
                self.stopActivityIndicator()
                if error != nil {
                    self.createAlert(message: error!.localizedDescription)
                }
                else {
                    self.dealerTableView.reloadData()
                }
            }
            
            
        }
    }
    
    // MARK: - View Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActivityIndicator()
        setupTableView()
        setupViewControllerDelegates()
        setupNavBar()
        refreshAssessments()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.dealerTableView.reloadData()
    }
    
    // MARK: - VC Setup Functions
    
    private func setupActivityIndicator() {
        self.activityIndicator.activityIndicatorViewStyle = .white
        self.activityIndicator.hidesWhenStopped = true
        //self.activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        let constX:NSLayoutConstraint = NSLayoutConstraint(item: self.activityIndicator, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0);
        let constY:NSLayoutConstraint = NSLayoutConstraint(item: self.activityIndicator, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0);
        self.view.addConstraints([constX, constY]);
    }
    
    private func setupTableView() {
        self.dealerTableView.delegate = self
        self.dealerTableView.dataSource = self
        self.dealerTableView.backgroundColor = UIColor.black
    }
    
    private func setupViewControllerDelegates() {
        let del = UIApplication.shared.delegate as! AppDelegate
        del.notifier = self
    }
    
    private func setupNavBar() {
        self.navigationItem.title = "Area Managers"

    }
    
    // MARK: - Activity Indicator Functions
    
    private func startActivityIndicator() {
        self.activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }

    private func stopActivityIndicator() {
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()

    }
    // MARK: - Table View Data Source/Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return DealerManager.shared.dealers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let dealer = DealerManager.shared.dealers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "dealerInfoCell")! as! ManagerInfoTableViewCell
        cell.managerNameLabel.text = "\(dealer.getFirstName()) \(dealer.getSecondName())"
        cell.managerIDLabel.text = "\(DealerManager.shared.dealers[indexPath.row].getID())"
        cell.managerNameLabel.textColor = UIColor.white
        cell.managerIDLabel.textColor = UIColor.white
        
        let numberOfAssessments = AssessmentManager.shared.numberOfAssessmentsFor(dealer: dealer)
        
        if numberOfAssessments >= 200 {
            cell.numberOfAssessmentsLabel.textColor = .green

        }
        else if numberOfAssessments < 200 && numberOfAssessments >= 100 {
            cell.numberOfAssessmentsLabel.textColor = .yellow

        }
        else {
            cell.numberOfAssessmentsLabel.textColor = .red

        }
        cell.backgroundColor = UIColor.black
        cell.numberOfAssessmentsLabel.text = "Number Of Assessments: \(numberOfAssessments)"
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dealerOptionVC") as! DealerOptionViewController
        vc.dealer = DealerManager.shared.dealers[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("Did deselect")
        
    }
    
    func assessmentsDownloadComplete() {
        self.dealerTableView.reloadData()
    }
    
    func dealerDownloadComplete() {
        
    }
    
    private func createAlert(message : String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Wifi Settings", style: .default, handler: {(action) in
            
            alert.dismiss(animated: true, completion: nil)
            UIApplication.shared.open(URL(string: "App-Prefs:root=WIFI")!)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(action) in
            
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    

}
