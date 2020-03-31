//
//  CacheStore.swift
//  Client_IOS12
//
//  Created by 千田伸一郎 on 2020/03/24.
//  Copyright © 2020 千田伸一郎. All rights reserved.
//

import Foundation

enum CacheStoreError: Error {
    case read
    case save
    case parse
    case unknown(String) // String型を引数とする
}

class CacheStore {
    static let shared = CacheStore()
    private init() {}
    private let saveDir = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)[0]
    
    
    func save<T:Codable>(data:T, to:String) throws {
        let file:URL = URL(fileURLWithPath: saveDir + to)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        do {
            let encoded = try! encoder.encode(data)
            try encoded.write(to: file)
        } catch {
            print("Unable to encode or save wallet key !")
            throw CacheStoreError.save
        }
    }
    
    func read<T:Codable>(from:String) throws -> T {
        let file:URL = URL(fileURLWithPath: saveDir + from)
        let decoder: JSONDecoder = JSONDecoder()
        do {
            let raw = try! Data(contentsOf: file)
            return try decoder.decode(T.self, from: raw)
        } catch {
            print("Unable to load or decode wallet key !" )
            throw CacheStoreError.parse
        }
        
    }
    
    func exists(fileName:String)->Bool {
        let file:URL = URL(fileURLWithPath: saveDir + fileName)
        return FileManager.default.fileExists(atPath: file.path)
    }
}
