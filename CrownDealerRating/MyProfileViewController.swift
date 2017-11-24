//
//  MyProfileViewController.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 19/11/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import UIKit
import JBChart

class MyProfileViewController: UIViewController, JBLineChartViewDataSource, JBLineChartViewDelegate, UIGestureRecognizerDelegate {
    
    private let groups = ["Managing Self", "Accountability", "Service", "Communication", "Teamwork"]
    private var assessmentScores : [AssessmentScore] = []
    private var areaAssessmentScores : [AssessmentScore] = []
    private let scoreURLString = "http://18.221.45.138/scores.php"
    private let employeeURL = "http://18.221.45.138/employees.php"
    private let areaScoreURLString = ""
    private var groupIndex: Int = 0
    private let delegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var employeeImageView: UIImageView!
    
    @IBOutlet weak var employeeNameLabel: UILabel!
    
    @IBOutlet weak var employeeIDLabel: UILabel!
    @IBOutlet weak var chartView: JBLineChartView!
    
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var prevButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emptyLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.chartView.dataSource = self
        self.chartView.delegate = self
        self.typeLabel.text = ""
        self.groupLabel.text = ""
        self.updateButtonLabels()
        self.updateDealerInfo()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        self.chartView.minimumValue = 0.0
        self.chartView.maximumValue = 1.0
        self.employeeImageView.layer.cornerRadius = self.employeeImageView.frame.width/2
        self.chartView.clearsContextBeforeDrawing = true
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.downloadScoresForGroupIndex()
    }
    
    // MARK: - IBActions
    
    @IBAction func prevGroup() {
        self.groupIndex = prevGroupIndex()
        self.downloadScoresForGroupIndex()
        self.updateButtonLabels()
        self.updateLabels(lineIndex: nil)

    }
    
    @IBAction func nextGroup() {
        self.groupIndex = nextGroupIndex()
        self.downloadScoresForGroupIndex()
        self.updateButtonLabels()
        self.updateLabels(lineIndex: nil)


    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func lineChartView(_ lineChartView: JBLineChartView!, verticalValueForHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        let index = Int(horizontalIndex)
        if lineIndex == 0 {
            return CGFloat(self.assessmentScores[index].score)
        }
        else {
            print("Line Index \(lineIndex)")
            return CGFloat(self.areaAssessmentScores[index].score)
        }
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, showsDotsForLineAtLineIndex lineIndex: UInt) -> Bool {
        return true
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
        
        return UInt(self.assessmentScores.count)
        
    }
    func numberOfLines(in lineChartView: JBLineChartView!) -> UInt {
        
        if self.assessmentScores.count == 0 {
            UIView.animate(withDuration: 1.3, animations: {
                self.emptyLabel.isHidden = false
                print("Assessment Count Score 0")
                self.emptyLabel.alpha = 1
            })
            return 0
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.emptyLabel.alpha = 0
            //self.emptyLabel.isHidden = true
        })

        return 2
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, colorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        
        var color : UIColor!
        
        switch lineIndex {
        case 0:
            color = UIColor(red: 0.4, green: 0.4, blue: 1.0, alpha: 1.0)
        case 1:
            color = UIColor.yellow
        case 2:
            color = UIColor.green
        default:
            color = UIColor.black
        }
        
        return color
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, colorForDotAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> UIColor! {
        var color : UIColor!
        
        switch lineIndex {
        case 0:
            color = UIColor.blue
        case 1:
            color = UIColor.yellow
        case 2:
            color = UIColor.green
        default:
            color = UIColor.black
        }
        
        return color
    }
    
    
    func lineChartView(_ lineChartView: JBLineChartView!, didSelectLineAt lineIndex: UInt, horizontalIndex: UInt) {
        let index = Int(horizontalIndex)
        self.updateLabels(lineIndex: index)
    }
    
    func didDeselectLine(in lineChartView: JBLineChartView!) {
        self.updateLabels(lineIndex: nil)
    }
    
    func downloadScoresForGroupIndex() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        //UIApplication.shared.beginIgnoringInteractionEvents()
        let user = self.delegate.user
        let groupString = self.groups[groupIndex].replacingOccurrences(of: " ", with: "%20")
        let urlString :String = "\(self.scoreURLString)?group=\(groupString)&empID=\(user!.id)"
        print(urlString)
        let queue = DispatchQueue(label: "Download Queue")
        queue.async {
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
                UIApplication.shared.beginIgnoringInteractionEvents()
            }
            let sem = DispatchSemaphore(value: 0)
            NetworkManager.shared.getData(from: urlString, completion: {data, error in
                do {
                    self.assessmentScores = try JSONDecoder().decode([AssessmentScore].self, from: data!)
                    print("First Sem Signal")
                    sem.signal()
                }
                catch {
                    print(error.localizedDescription)
                }
            })
            sem.wait()
            print("Afer First Sem Wait")
            
            let areaURLString = "\(urlString)&area=\(user!.area.replacingOccurrences(of: " ", with: "%20"))"
            NetworkManager.shared.getData(from: areaURLString, completion: {data, error in
                do {
                    self.areaAssessmentScores = try JSONDecoder().decode([AssessmentScore].self, from: data!)
    
                    sem.signal()
                    
                }
                catch {
                    print(error.localizedDescription)
                }
                
            })
            sem.wait()
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                print("Self Assessment Count: \(self.assessmentScores.count)")
                self.chartView.layoutSubviews()
                self.chartView.reloadData(animated: true)
                UIApplication.shared.endIgnoringInteractionEvents()
                self.updateLabels(lineIndex: nil)

            }

        }
        
        //UIApplication.shared.endIgnoringInteractionEvents()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false

    }
    
    private func updateLabels(lineIndex : Int?) {
        if lineIndex == nil {
            self.groupLabel.text = "Assessment Group: \(self.groups[self.groupIndex])"
            self.typeLabel.attributedText = self.typeLabelPlaceholder(userScore: nil, areaScore: nil)
        }
        else {
            self.typeLabel.attributedText = self.typeLabelPlaceholder(userScore: self.assessmentScores[lineIndex!].score ,areaScore: self.areaAssessmentScores[lineIndex!].score)
            let description = self.assessmentScores[lineIndex!].assessmentType.type
            self.groupLabel.text = description
        }
    }
    
    private struct AssessmentScore: Decodable {
        var score : Double
        var assessmentType : AssessmentLadder.AssessmentType
    }
    
    private func typeLabelPlaceholder(userScore: Double?, areaScore: Double?) -> NSMutableAttributedString {
        let userAttributes = [NSAttributedStringKey.foregroundColor : UIColor.blue]
        let teamAttributes = [NSAttributedStringKey.foregroundColor : UIColor.yellow]

        if userScore == nil || areaScore == nil {
            var userString = NSMutableAttributedString(string: "\(self.delegate.user!.firstName)'s Scores", attributes: userAttributes)
            let teamString = NSMutableAttributedString(string: "\(self.delegate.user!.area)'s Scores", attributes: teamAttributes)
            userString.append(NSAttributedString(string: "\t\t\t"))
            userString.append(teamString)
            return userString

        }
        else {
            var userString = NSMutableAttributedString(string: "\(Int(userScore!*100))/100", attributes: userAttributes)
            let teamString = NSMutableAttributedString(string: "\(Int(areaScore!*100))/100", attributes: teamAttributes)
            userString.append(NSAttributedString(string: "\t\t\t"))
            userString.append(teamString)
            return userString

        }
        
    }
    
    private func updateDealerInfo() {
        var employee: AssessmentLadder.Employee?
        let urlString = "\(self.employeeURL)?empID=\(self.delegate.user!.id)"
        
        let queue = DispatchQueue(label: "Download Queue")
        queue.async {
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
            
            NetworkManager.shared.getData(from: employee!.photoURL, completion: {data, error in
                DispatchQueue.main.async {
                    self.employeeImageView.image = UIImage(data: data!)
                    self.employeeNameLabel.text = "\(employee!.firstName) \(employee!.lastName)"
                    self.employeeIDLabel.text = "\(employee!.id)"
                }
                
                sem.signal()
            })
            sem.wait()
        }
        
    }
    
    private func updateButtonLabels() {
        self.nextButton.setTitle("\(self.groups[nextGroupIndex()]) \u{21e8}", for: .normal)
        self.prevButton.setTitle("\u{21e6} \(self.groups[prevGroupIndex()])", for: .normal)
    }
    
    private func nextGroupIndex() -> Int {
        if self.groupIndex == self.groups.count-1 {
            return 0
        }
        else {
            return self.groupIndex + 1
        }
    }
    
    private func prevGroupIndex() -> Int {
      
        if self.groupIndex == 0 {
            print("Prev Index Is \(self.groups.count-1)")
            return self.groups.count-1
        }
        else {
            print("Prev Index Is \(self.groupIndex - 1)")
            return self.groupIndex - 1
        }
    }
    
    private func setupLoadingIndicator() {
        
    }

}
