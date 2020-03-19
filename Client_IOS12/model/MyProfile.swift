//
//  MyProfile.swift
//  GoodPoint_IOS_Prot
//
//  Created by 千田伸一郎 on 2020/02/21.
//  Copyright © 2020 千田伸一郎. All rights reserved.
//

import Foundation

//var myProfile = MyProfile()

var myProfile = MyProfile()
var employeeData:[Employee] = employeeMaster

final class MyProfile {
    //var isSet: Bool = false
    //var employees:[Employee] = employeeData
    var me: Employee = employeeData[0]
    var index : Int = 0

    private func _renewEmplyoeeData(){
        employeeData.removeAll()
        for e in employeeMaster {
            if e.address != myProfile.me.address {
                employeeData.append(e)
            }
        }
    }

    func setProfile(index:Int){
        self.index = index
        self.me = employeeMaster[index]
        _renewEmplyoeeData()
    }
}
