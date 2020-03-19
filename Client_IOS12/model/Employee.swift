//
//  Employee.swift
//  GoodPoint_IOS_Prot
//
//  Created by 千田伸一郎 on 2020/02/14.
//  Copyright © 2020 千田伸一郎. All rights reserved.
//

//import Foundation
import SwiftUI

struct Employee: Hashable, Codable,Identifiable {
    var id: Int
    var address: String
    var privateKey: String
    var name: String
//    var point: String
    fileprivate var imageName: String
    var category: Category
//    var isMiner: Bool

    enum Category: String, CaseIterable, Codable, Hashable {
        case board = "取締役"
        case fin1 = "金融システム開発第１部"
        case fin2 = "金融システム開発第２部"
        case prod = "プロダクト部"
    }
}

extension Employee {
    var image: UIImage {
        ImageStore.shared.image(name: imageName)
    }
}
//extension Employee: Equatable {
//    public static func ==(lhs:Employee, rhs:Employee) -> Bool {
//            return lhs.id == rhs.id
//    }
//}
