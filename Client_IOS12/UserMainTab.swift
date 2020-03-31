//
//  UserMainTab.swift
//  Client_IOS12
//
//  Created by 千田伸一郎 on 2020/03/17.
//  Copyright © 2020 千田伸一郎. All rights reserved.
//

import UIKit

class UserMainTab: UITabBarController {

    @IBAction func tapRefresh(_ sender: Any) {
        if pointData.refresh() {}
        self.selectedViewController?.viewWillAppear(false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if pointData.refresh() { }
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
