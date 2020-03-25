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
    
    
    func save<T:Codable>(data:T, to:String) throws {
        let file:URL = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] + to)
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
        let file:URL = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] + from)
        let decoder: JSONDecoder = JSONDecoder()
        let raw = try! Data(contentsOf: file)
        do {
            return try decoder.decode(T.self, from: raw)
        } catch {
            print("Unable to load or decode wallet key !" )
            throw CacheStoreError.parse
        }
        
    }
    
    func exists(fileName:String)->Bool {
        return FileManager.default.fileExists(atPath: fileName)
    }
}
