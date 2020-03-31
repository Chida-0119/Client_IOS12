//
//  EmployeeDetail.swift
//  Client_IOS12
//
//  Created by 千田伸一郎 on 2020/03/16.
//  Copyright © 2020 千田伸一郎. All rights reserved.
//

import UIKit

class EmployeeDetail: UIViewController {
    //var myProfile: MyProfile = myProfile
    var employee: Employee  = employeeData[0]
    //var pointData: PointData = PointData()
    var ActivityIndicator: UIActivityIndicatorView!
    //var activityIndicatorView = UIActivityIndicatorView()

    @IBOutlet weak var myProfileImage: UIImageView!
    @IBOutlet weak var employeeImage: UIImageView!
    @IBOutlet weak var myProfileDispName: UILabel!
    @IBOutlet weak var employeeDispName: UILabel!
    
    @IBOutlet weak var goodPointAmount: UITextField!
    @IBOutlet weak var myGrantedPoint: UILabel!
    @IBOutlet weak var empGoodPoint: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
      super.init(nibName: nil, bundle: nil)
    }

    convenience init() {
      self.init(nibName: nil, bundle: nil)
    }

    @IBAction func tapSend(_ sender: Any) {
        
        let amount = self.goodPointAmount.text!
        ActivityIndicator.startAnimating()
        
        
        DispatchQueue.global(qos: .default).async {
            let ethAccess = EthAccess(con: connectConfig)

            ethAccess.sendGood(toAddress: self.employee.address, value: amount)
            if pointData.refresh() {}
            //self.dismiss(animated: true, completion: nil)
            DispatchQueue.main.async {
                self.ActivityIndicator.stopAnimating()
                self.navigationController?.popViewController(animated: true)
            }
        }

    }
    
    @IBAction func changeStepper(_ sender: UIStepper) {
        goodPointAmount.text = String(Int(sender.value))
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myGrantedPoint.text = "付与ポイント:\(String(pointData.granted[MyProfile.shared.address!]!))"
        empGoodPoint.text = "いいね！:\(String(pointData.given[employee.address]!))"
        goodPointAmount.text = "1"
        myProfileImage.image = MyProfile.shared.me!.image
        myProfileDispName.text = MyProfile.shared.me!.name
        employeeImage.image = employee.image
        employeeDispName.text = employee.name
            
        myProfileImage.layer.masksToBounds = true
        myProfileImage.layer.cornerRadius = myProfileImage.bounds.width / 2
        employeeImage.layer.masksToBounds = true
        employeeImage.layer.cornerRadius = employeeImage.bounds.width / 2
        
        ActivityIndicator = UIActivityIndicatorView()
        ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        ActivityIndicator.center = self.view.center
        // クルクルをストップした時に非表示する
        ActivityIndicator.hidesWhenStopped = true
        // 色を設定
        ActivityIndicator.style = UIActivityIndicatorView.Style.gray

        view.addSubview(ActivityIndicator)

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

}
