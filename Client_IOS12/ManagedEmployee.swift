//
//  ManagedEmployee.swift
//  Client_IOS12
//
//  Created by 千田伸一郎 on 2020/03/17.
//  Copyright © 2020 千田伸一郎. All rights reserved.
//

import UIKit

class ManagedEmployee: UIViewController {

    var employee: Employee = UserMaster.shared.users[MyProfile.shared.me.address]!
    @IBOutlet weak var employeeImage: UIImageView!
    @IBOutlet weak var employeeDispName: UILabel!
    @IBOutlet weak var grantedPoint: UILabel!
    @IBOutlet weak var goodPoint: UILabel!
    @IBOutlet weak var addGrantedAmount: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        employeeImage.image = employee.image
        employeeDispName.text = employee.name
        grantedPoint.text = pointData.granted[employee.address] ?? "0"
        goodPoint.text = pointData.given[employee.address] ?? "0"
        addGrantedAmount.text = "0"

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func execAddGranted(_ sender: Any) {
        let ethAccess = EthAccess(con: connectConfig)
        
        ethAccess.addGood(toAddress: employee.address, value: addGrantedAmount.text!)
        if pointData.refresh() {}
        self.navigationController?.popViewController(animated: true)
    }
}
