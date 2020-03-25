//
//  ManagedDirectory.swift
//  Client_IOS12
//
//  Created by 千田伸一郎 on 2020/03/17.
//  Copyright © 2020 千田伸一郎. All rights reserved.
//

import UIKit

class ManagedDirectory: UITableViewController {
    
    private struct _Employee {
        var name : String
        var address: String
    }
    private var selectedEmployee: Employee = MyProfile.shared.me
    private var _data:[_Employee] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "EmployeeRow", bundle: nil), forCellReuseIdentifier: "EmployeeRow")

        for (_ , e) in UserMaster.shared.users {
            _data.append(_Employee(name:e.name, address: e.address))
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toManageEmployee") {
            let employeeDetailVC: ManagedEmployee = segue.destination as! ManagedEmployee
            
            employeeDetailVC.employee = self.selectedEmployee
        }
    }
    @IBAction func tapRefreshData(_ sender: Any) {
        if pointData.refresh() {}
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeRow", for: indexPath ) as! EmployeeRow

        let _address = _data[indexPath.row].address
        cell.hiddenGranted = false
        cell.hiddenGood = true
        cell.setCell(employee:UserMaster.shared.users[_address]!, grantedPoint: pointData.granted[_address] ?? "0" , goodPoint: pointData.given[_address] ?? "0" )
      return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _data.count
    }

    override func tableView(_ table: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
    
        let _address = _data[indexPath.row].address
        self.selectedEmployee = UserMaster.shared.users[_address]!
        
        // 別の画面に遷移
        performSegue(withIdentifier: "toManageEmployee", sender: nil)
    }


}
