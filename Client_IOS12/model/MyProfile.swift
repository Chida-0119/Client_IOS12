//
//  MyProfile.swift
//  GoodPoint_IOS_Prot
//
//  Created by 千田伸一郎 on 2020/02/21.
//  Copyright © 2020 千田伸一郎. All rights reserved.
//

import Foundation

//var myProfile = MyProfile()

//var myProfile = MyProfile()
var employeeData:[Employee] = {
    var _ret:[Employee] = []
    for (_, e) in UserMaster.shared.users {
        _ret.append(e)
    }
    return _ret
}()

struct WalletKey: Codable {
    var address: String
    var privateKey: String
}

class MyProfile : NSObject {
    static var shared = MyProfile()
    //private var walletKey:WalletKey
    //var address: String = "0x6b0eEa30d84F0B88e07d7c649e3D0cbe8D3F15c3"
    //var privateKey: String = "67d6b6fdb373ac2d054e369c0debd0aba03ab6ded4299f0c81ec2bcae5f67070"
    //var me: Employee = UserMaster.shared.users["0x6b0eEa30d84F0B88e07d7c649e3D0cbe8D3F15c3"]!
    var address: String?
    var privateKey: String?
    var me: Employee?
    //var index : Int = 0

    override private init() { }

    enum MyProfileError : Error {
        case load
        case setProfile
        case unknown(String)
    }
    
    func load() throws {
        do {
            let walletKey = try CacheStore.shared.read(from: "walletKey.json") as WalletKey
            self.address = walletKey.address
            self.privateKey = walletKey.privateKey
            self.me = UserMaster.shared.users[self.address!]!
        } catch {
            print("Unable to load wallet key file from local cache")
            throw MyProfileError.load
        }
    }
    
    private func _renewEmplyoeeData(_ address:String){
        employeeData.removeAll()
        for (_,data) in UserMaster.shared.users {
            if data.address != address {
                employeeData.append(data)
            }
        }
    }

    func setProfile(address:String){
        //self.index = index
        self.me = UserMaster.shared.users[address]!
        self.address = self.me!.address
        self.privateKey = self.me!.privateKey
        _renewEmplyoeeData(address)
        
        try! CacheStore.shared.save(data: WalletKey(address:self.address!, privateKey: self.privateKey!) , to: "walletKey.json")
    }
}
