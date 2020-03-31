//
//  EmployeeDirectory.swift
//  Client_IOS12
//
//  Created by 千田伸一郎 on 2020/03/12.
//  Copyright © 2020 千田伸一郎. All rights reserved.
//

import Foundation
import UIKit

class EmployeeDirectory: UITableViewController  {
    var selectedEmployee: Employee = employeeData[0]
    private var freshness = Date()
    private var currentAddress:String = MyProfile.shared.address!
    

    @IBAction func refreshTableView(_ sender: Any) {
        if pointData.refresh() {}
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeRow", for: indexPath ) as! EmployeeRow

        let _address = employeeData[indexPath.row].address
        cell.hiddenGranted = true
        cell.setCell(employee:employeeData[indexPath.row], grantedPoint: pointData.granted[_address] ?? "0" , goodPoint: pointData.given[_address] ?? "0" )
      return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if currentAddress != MyProfile.shared.address! || freshness.compare(pointData.freshness) == .orderedAscending {
            currentAddress = MyProfile.shared.address!
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "EmployeeRow", bundle: nil), forCellReuseIdentifier: "EmployeeRow")
        freshness = pointData.freshness
        currentAddress = MyProfile.shared.address!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeeData.count
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toTransferEffToken") {
            let employeeDetailVC: EmployeeDetail = segue.destination as! EmployeeDetail
            
            employeeDetailVC.employee = self.selectedEmployee
        }
    }


    override func tableView(_ table: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
    
        self.selectedEmployee = employeeData[indexPath.row]
        
        // 別の画面に遷移
        performSegue(withIdentifier: "toTransferEffToken", sender: nil)
    }
}
