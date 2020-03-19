//
//  TopMenuView.swift
//  Client_IOS12
//
//  Created by 千田伸一郎 on 2020/03/17.
//  Copyright © 2020 千田伸一郎. All rights reserved.
//

import UIKit

class TopMenu: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myProfile.setProfile(index: 0)
        if pointData.refresh() { }
    }

    /*
    @IBAction func tapManagedDirectory(_ sender: Any) {
       let storyboard: UIStoryboard = self.storyboard!
        let managedView = storyboard.instantiateViewController(withIdentifier: "ManagedDirectory")
        let navi = UINavigationController(rootViewController: managedView)
        //present(navi, animated: false, completion: nil)
        navi.modalTransitionStyle = .coverVertical
        present(navi, animated: true, completion: nil)
        //self.navigationController?.pushViewController(managedView, animated: true)
    }
 */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
