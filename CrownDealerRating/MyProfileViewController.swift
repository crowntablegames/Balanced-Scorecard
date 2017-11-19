//
//  MyProfileViewController.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 19/11/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import UIKit
import JBChart

class MyProfileViewController: UIViewController, JBLineChartViewDataSource, JBLineChartViewDelegate {
    
    @IBOutlet weak var chartView: JBLineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chartView.dataSource = self
        self.chartView.delegate = self
        self.chartView.minimumValue = 0
        self.chartView.maximumValue = 1
        self.chartView.reloadData()
        // Do any additional setup after loading the view.
    }
    
//    func numberOfLines(in lineChartView: JBLineChartView!) -> UInt {
//        return 2
//    }
//
//    func lineChartView(_ lineChartView: JBLineChartView!, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
//        return 20
//    }
//
//    func lineChartView(_ lineChartView: JBLineChartView!, verticalValueForHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
//        return 10
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func lineChartView(_ lineChartView: JBLineChartView!, verticalValueForHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        
        return CGFloat(20.0)
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, showsDotsForLineAtLineIndex lineIndex: UInt) -> Bool {
        return true
    }
    
    
    
    func lineChartView(_ lineChartView: JBLineChartView!, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
        
        return UInt(2)
        
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
        
        
    }
    
    func didDeselectLine(in lineChartView: JBLineChartView!) {
        
    }

}
