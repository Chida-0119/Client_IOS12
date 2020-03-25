//
//  ViewController.swift
//  Client_IOS12
//
//  Created by 千田伸一郎 on 2020/03/13.
//  Copyright © 2020 千田伸一郎. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var profileImage : UIImageView!
    @IBOutlet weak var profileDispName: UILabel!
    @IBOutlet weak var grantedPoint: UILabel!
    @IBOutlet weak var goodPoint: UILabel!
    
    private var savedAddress:String = MyProfile.shared.address
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
      super.init(nibName: nil, bundle: nil)
    }

    convenience init() {
      self.init(nibName: nil, bundle: nil)
//      self.setProfile(index: 0)
    }

    /*
    func setProfile(index:Int){
        MyProfile.shared.setProfile(index: index)
    }
*/
    override func viewWillAppear(_ animaated:Bool){
        super.viewWillAppear(animaated)
        if self.savedAddress != MyProfile.shared.address {
            self.profileDispName.text = MyProfile.shared.me.name as String
            self.profileImage.image = MyProfile.shared.me.image as UIImage
            self.grantedPoint.text = pointData.granted[MyProfile.shared.address]
            self.goodPoint.text = pointData.given[MyProfile.shared.address]
            self.savedAddress = MyProfile.shared.address
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

