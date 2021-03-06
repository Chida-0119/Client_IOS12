//
//  PointData.swift
//  GoodPoint_IOS_Prot
//
//  Created by 千田伸一郎 on 2020/02/19.
//  Copyright © 2020 千田伸一郎. All rights reserved.
//

import Combine
import SwiftUI

//let ethAccess = EthAccess(con: connectConfig, prof: myProfile)

var pointData = PointData()

final class PointData {
    var freshness = Date()
    //var isSet: Bool = false
    //var employees:[Employee] = employeeData
    //var granted: [String:String] = ["0x6b0eEa30d84F0B88e07d7c649e3D0cbe8D3F15c3":"0"]
    static let zeroPoints : () -> [String:String] = {
        var _ret:[String : String] = [:]
        for (_ , data) in UserMaster.shared.users {
                    _ret[data.address] = "0"
        }
        return _ret
    }
    var granted: [String:String] = zeroPoints()
    var given: [String:String] = zeroPoints()
        
    func refresh() -> Bool {
        let ethAccess = EthAccess(con: connectConfig)
        for (_ , data) in UserMaster.shared.users {
            self.given[data.address] = ethAccess.getBalance(address: data.address)!
            self.granted[data.address] = ethAccess.getGranted(address: data.address)!
        }
        freshness = Date()
        return true
    }
}
