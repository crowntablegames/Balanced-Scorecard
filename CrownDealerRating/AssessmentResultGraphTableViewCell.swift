//
//  AssessmentResultGraphTableViewCell.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 8/8/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import UIKit
import JBChart

public protocol AssessmentResultCellDelegate {
    func chartIsTouched()
    func chartIsUntouched()
}

class AssessmentResultGraphTableViewCell: UITableViewCell, JBLineChartViewDelegate, JBLineChartViewDataSource {
    
    public var dealer : Dealer!
    public var dealerAssessmentValues : [Float] = []
    public var teamAverageAssessmentValues : [Float] = []
    public var assessmentGroup : String!
    public var assessmentTypes: [AssessmentManager.AssessmentType] = []
    
    @IBOutlet weak var dealerNameLabel: UILabel!
    
    @IBOutlet weak var dealerAreaLabel: UILabel!
    
    @IBOutlet weak var assessmentGroupLabel: UILabel!
    public var delegate : AssessmentResultCellDelegate?
    
    @IBOutlet weak var lineChart: JBLineChartView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.lineChart.dataSource = self
        self.lineChart.delegate = self
        self.lineChart.minimumValue = 0
        self.lineChart.maximumValue = 1
        
    }
    
    public func updateResultsWith(resultsDictionary : NSDictionary) -> Bool {
        
        return false
    }
    
    
    
    public func updateResultsFor(dealer : Dealer, resultsDictionary: NSDictionary) {
        self.assessmentGroup = resultsDictionary.value(forKey: "group") as! String
        self.dealer = dealer
        self.dealerAssessmentValues = resultsDictionary.value(forKey: "dealerAssessmentScores") as! [Float]
        
        self.teamAverageAssessmentValues = resultsDictionary.value(forKey: "teamAssessmentScores") as! [Float]
        
        
        let array = resultsDictionary.value(forKey: "groupAssessmentTypes") as! [NSDictionary]
        self.assessmentTypes = []
        for dict in array {
            let aType = AssessmentManager.AssessmentType.init(assessmentTypeDictionary: dict)
            
            self.assessmentTypes.append(aType)
        }
    
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutSubviews()
        print("Cell layed out subviews")
        let footerView = UIView(frame: CGRect(origin: self.lineChart.frame.origin, size: CGSize(width: self.lineChart.bounds.width, height: 40)))
        footerView.backgroundColor = UIColor.black
        
        for multiplier in 0...assessmentTypes.count-1 {
            let width = footerView.bounds.width/CGFloat(assessmentTypes.count)
            let x = width * CGFloat(multiplier)
            let frame = CGRect(x: x, y: 0, width: width, height: 40)
            let labelView1 = UILabel(frame : frame)
            if multiplier % 2 == 0 {
                labelView1.backgroundColor = .black
            }
            else {
                
                labelView1.backgroundColor = .darkGray

            }
            labelView1.text = "\(self.assessmentTypes[multiplier].id)"
            labelView1.textColor = .white
            labelView1.textAlignment = .center
            footerView.addSubview(labelView1)
            

        }
        let labelView2 = UIView(frame : frame)
        labelView2.backgroundColor = .green
        footerView.addSubview(labelView2)
        
        self.dealerNameLabel.text = "\(self.dealer.getFirstName()) \(dealer.getSecondName())"
        self.dealerAreaLabel.text = "\(self.dealer.area!.rawValue) Average"
        self.assessmentGroupLabel.text = "\(self.assessmentGroup!)"

        self.lineChart.footerView =  footerView
        self.lineChart.footerView.backgroundColor = UIColor.white
        self.lineChart.reloadData()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    public func valuesForAssessmentTypes() {
        
    }
    
    // MARK: - JBLineChartView
    
    func lineChartView(_ lineChartView: JBLineChartView!, dotViewAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> UIView! {
        
        let bounds = lineChart.bounds
        let frame = CGRect(x: 0, y: 0, width: bounds.height/10, height: bounds.height/10)
        var label = UILabel(frame: frame)
        
        if dealerAssessmentValues.count == 0 {
            label.text = ""
        }
        else if lineIndex == 0 {
            label.text = String(dealerAssessmentValues[Int(horizontalIndex)])
        }
        else {
            label.text = String(teamAverageAssessmentValues[Int(horizontalIndex)])

        }
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.8)
        label.center = CGPoint(x:frame.width/2 , y: frame.height/2)
        label.clipsToBounds = true
        label.layer.cornerRadius = label.frame.width/2
        
        return label
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, verticalValueForHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        
        if dealerAssessmentValues.count == 0 {
            
            return CGFloat(0)
        }
        
        if lineIndex == 0  {
            return CGFloat(dealerAssessmentValues[Int(horizontalIndex)])
        }
        else {
           
            return CGFloat(teamAverageAssessmentValues[Int(horizontalIndex)])
        }
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, showsDotsForLineAtLineIndex lineIndex: UInt) -> Bool {
        return true
    }
    
    
    
    func lineChartView(_ lineChartView: JBLineChartView!, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
        
       return UInt(assessmentTypes.count)
        
    }
    func numberOfLines(in lineChartView: JBLineChartView!) -> UInt {
        
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
        self.delegate?.chartIsTouched()
        
        let assessmentType = self.assessmentTypes[Int(horizontalIndex)]
        let dealerValue = self.dealerAssessmentValues[Int(horizontalIndex)]
        let teamAverageValue = self.teamAverageAssessmentValues[Int(horizontalIndex)]
        
        self.assessmentGroupLabel.text = "\(assessmentType.type)"
        self.dealerNameLabel.text = "\(dealer.getFirstName()): \(dealerValue)"
        self.dealerAreaLabel.text = "\(dealer.area!.rawValue) Average: \(teamAverageValue)"
        
    }
    
    func didDeselectLine(in lineChartView: JBLineChartView!) {
        self.delegate?.chartIsUntouched()
        self.assessmentGroupLabel.text = "\(self.assessmentGroup!)"

        self.dealerNameLabel.text = "\(self.dealer.getFirstName()) \(dealer.getSecondName())"
        self.dealerAreaLabel.text = "\(self.dealer.area!.rawValue) Average"
    }
}
