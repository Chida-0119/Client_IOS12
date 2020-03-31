//
//  UserMainTab.swift
//  Client_IOS12
//
//  Created by 千田伸一郎 on 2020/03/17.
//  Copyright © 2020 千田伸一郎. All rights reserved.
//

import UIKit

class UserMainTab: UITabBarController {
    
    var ActivityIndicator: UIActivityIndicatorView!

    @IBAction func tapRefresh(_ sender: Any) {

        ActivityIndicator.startAnimating()
        
        DispatchQueue.global(qos: .default).async {
            if pointData.refresh() {}
            
            DispatchQueue.main.async {
                self.selectedViewController?.viewWillAppear(false)
                self.ActivityIndicator.stopAnimating()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if pointData.refresh() { }
        ActivityIndicator = UIActivityIndicatorView()
        ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        ActivityIndicator.center = self.view.center
        // クルクルをストップした時に非表示する
        ActivityIndicator.hidesWhenStopped = true
        // 色を設定
        ActivityIndicator.style = UIActivityIndicatorView.Style.gray

        view.addSubview(ActivityIndicator)

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
