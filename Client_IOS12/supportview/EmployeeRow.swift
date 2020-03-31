//
//  EmployeeRow.swift
//  Client_IOS12
//
//  Created by 千田伸一郎 on 2020/03/12.
//  Copyright © 2020 千田伸一郎. All rights reserved.
//

import UIKit

class EmployeeRow: UITableViewCell {

    @IBOutlet weak var goodPoint: UILabel!
    @IBOutlet weak var grantedPoint: UILabel!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var employeeImage: UIImageView!
    @IBOutlet weak var grantedPointLabel: UILabel!
    @IBOutlet weak var goodPointLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(employee:Employee, grantedPoint:String, goodPoint:String) {
        self.displayName.text = employee.name as String
        self.grantedPoint.text = grantedPoint as String
        self.goodPoint.text = goodPoint as String

        self.employeeImage.image = employee.image
        //self.employeeImage.frame = CGRect(x: 50, y: 150, width: 300, height: 300)
        self.employeeImage.layer.cornerRadius = self.employeeImage.frame.width * 0.5
        self.employeeImage.clipsToBounds = true

    }

    var hiddenGranted :Bool = true {
        didSet {
            grantedPoint.isHidden = hiddenGranted
            grantedPointLabel.isHidden = hiddenGranted
            //pointLabelHeigjtConst.constant = 0
            //grantedPointLabel. = true
        }
    }
    var hiddenGood :Bool = true {
        didSet {
            goodPoint.isHidden = hiddenGood
            goodPointLabel.isHidden = hiddenGood
            //pointLabelHeigjtConst.constant = 0
        }
    }
    
}

