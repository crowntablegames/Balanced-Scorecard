//
//  EmployeeTableViewCell.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 13/11/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {

    @IBOutlet weak var employeeImage : UIImageView!
    @IBOutlet weak var employeeNameLabel : UILabel!
    @IBOutlet weak var employeeDescLabel : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.employeeImage.layer.cornerRadius = self.employeeImage.frame.width/2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func update(with employee: AssessmentLadder.Employee, and image: UIImage) {
        print("---------------")
        print(employee)
        self.employeeImage.image = image
        self.employeeNameLabel.text = "\(employee.firstName) \(employee.lastName)"
        self.employeeDescLabel.text = "\(employee.id), \(employee.area)"
    }
    
    private func downloadImageFrom(url: String) {
        let sem = DispatchSemaphore(value: 0)
        NetworkManager.shared.getData(from: url, completion: {data, error in
            if let image = UIImage(data: data!) {
                DispatchQueue.main.async {
                    self.imageView?.image = image
                }
            }
            sem.signal()
        })
        sem.wait()
    }
    
}
