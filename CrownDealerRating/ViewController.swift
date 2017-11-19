//
//  ViewController.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 30/6/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mainDealerImage: UIImageView!
    @IBOutlet weak var comparisonDealerImage: UIImageView!
    
    var tree : BSTLadder<Int>? = BSTLadder<Int>(rankedArray: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a ni
        
        self.mainDealerImage.image = UIImage()
        
    }

}

