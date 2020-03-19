//
//  ManagedDirectory.swift
//  Client_IOS12
//
//  Created by 千田伸一郎 on 2020/03/17.
//  Copyright © 2020 千田伸一郎. All rights reserved.
//

import UIKit

class ManagedDirectory: UITableViewController {


    private var selectedEmployee: Employee = employeeMaster[0]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "EmployeeRow", bundle: nil), forCellReuseIdentifier: "EmployeeRow")
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
            // tableView.indexPathForSelectedRow
            // performSegue(withIdentifier: "toTransferEffToken", sender: nil)
            
            // 11. SecondViewControllerのtextに選択した文字列を設定する
            //employeeDetailVC.text = selectedText
        }
    }
    @IBAction func tapRefreshData(_ sender: Any) {
        if pointData.refresh() {}
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeRow", for: indexPath ) as! EmployeeRow

        let _address = employeeMaster[indexPath.row].address
        cell.hiddenGranted = false
        cell.hiddenGood = true
        cell.setCell(employee:employeeMaster[indexPath.row], grantedPoint: pointData.granted[_address] ?? "0" , goodPoint: pointData.given[_address] ?? "0" )
      return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeeMaster.count
    }

    override func tableView(_ table: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
    
        self.selectedEmployee = employeeMaster[indexPath.row]
        
        // 別の画面に遷移
        performSegue(withIdentifier: "toManageEmployee", sender: nil)
    }


}
