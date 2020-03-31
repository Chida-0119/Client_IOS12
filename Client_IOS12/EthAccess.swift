//
//  EthAccess.swift
//  GoodPoint_IOS_Prot
//
//  Created by 千田伸一郎 on 2020/02/17.
//  Copyright © 2020 千田伸一郎. All rights reserved.
//

import Foundation
import web3swift
import struct BigInt.BigUInt

struct Wallet {
    let address: String
    let data: Data
    let name: String
    let isHD: Bool
}

struct EthAccess {
    private let contractABI :String = {
        if let path: String = Bundle.main.path(forResource: "ContractABI", ofType: "txt") {
            do {
             return try String(contentsOfFile: path)
            } catch {
                fatalError("Couldn't load contractABI file content.")
            }
         }else {
             fatalError("Couldn't find contractABI file.")
         }
    }()
    

    private var endpoint  = "http://ethjpgzfv-dns-reg1.japaneast.cloudapp.azure.com:8540"
    fileprivate var provider : web3swift.Web3Provider
    private var ehtNet : web3
    private let password = "web3swift"
    private var wallet: Wallet
    private var privatekey : String = ""
    private var address : String = ""
    var _tokenAddress:String = "0x36F1A9af6458aCe117154eA854FE783f2000234D"
    
    mutating private func _setConnectConfig(con: ConnectConfig) {
             self.endpoint = con.destination.endpoint
             self._tokenAddress = con.destination.tokenAddress
             let formattedKey = privatekey.trimmingCharacters(in: .whitespacesAndNewlines)
             let dataKey = Data.fromHex(formattedKey)!
             let keystore = try! EthereumKeystoreV3(privateKey: dataKey, password: password)!
             let name = "New Wallet"
             let keyData = try! JSONEncoder().encode(keystore.keystoreParams)
             let address = keystore.addresses!.first!.address
             wallet = Wallet(address: address, data: keyData, name: name, isHD: false)
             
             provider =  Web3HttpProvider(URL(string: self.endpoint)!)!
             let keystoreManager = KeystoreManager([keystore])
        
             if con.isProxyEnable {
                 let config = provider.session.configuration
                 config.requestCachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
                 config.connectionProxyDictionary = [AnyHashable: Any]()
                 config.connectionProxyDictionary?[kCFNetworkProxiesHTTPEnable as String] = 1
                 config.connectionProxyDictionary?[kCFNetworkProxiesHTTPProxy as String] = con.proxyAddress
                 config.connectionProxyDictionary?[kCFNetworkProxiesHTTPPort as String] = con.proxyPort
             }
             ehtNet = web3(provider: provider)
             ehtNet.addKeystoreManager(keystoreManager)
    }
    
    init(con:ConnectConfig) {
        self.privatekey = MyProfile.shared.privateKey!
        self.address = MyProfile.shared.address!
        self.endpoint = con.destination.endpoint
        self._tokenAddress = con.destination.tokenAddress
        let formattedKey = privatekey.trimmingCharacters(in: .whitespacesAndNewlines)
        let dataKey = Data.fromHex(formattedKey)!
        let keystore = try! EthereumKeystoreV3(privateKey: dataKey, password: password)!
        let name = "New Wallet"
        let keyData = try! JSONEncoder().encode(keystore.keystoreParams)
        let address = keystore.addresses!.first!.address
        wallet = Wallet(address: address, data: keyData, name: name, isHD: false)
        
        provider =  Web3HttpProvider(URL(string: self.endpoint)!)!
        let keystoreManager = KeystoreManager([keystore])
   
        if con.isProxyEnable {
            let config = provider.session.configuration
            config.requestCachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
            config.connectionProxyDictionary = [AnyHashable: Any]()
            config.connectionProxyDictionary?[kCFNetworkProxiesHTTPEnable as String] = 1
            config.connectionProxyDictionary?[kCFNetworkProxiesHTTPProxy as String] = con.proxyAddress
            config.connectionProxyDictionary?[kCFNetworkProxiesHTTPPort as String] = con.proxyPort
        }
        ehtNet = web3(provider: provider)
        ehtNet.addKeystoreManager(keystoreManager)
        
    }
    
    mutating func changeWallet(address:String, privateKey:String ) -> Bool {
             self.privatekey = privateKey
             self.address = address
             let formattedKey = privatekey.trimmingCharacters(in: .whitespacesAndNewlines)
             let dataKey = Data.fromHex(formattedKey)!
             let keystore = try! EthereumKeystoreV3(privateKey: dataKey, password: password)!
             let name = "New Wallet"
             let keyData = try! JSONEncoder().encode(keystore.keystoreParams)
             let address = keystore.addresses!.first!.address
             wallet = Wallet(address: address, data: keyData, name: name, isHD: false)

             let keystoreManager = KeystoreManager([keystore])

             ehtNet = web3(provider: provider)
             ehtNet.addKeystoreManager(keystoreManager)
        
            return true
    }

    func getBalance(address: String) -> String? {
        var balanceString : String!
        
        let walletAddress = EthereumAddress(wallet.address)! // Your wallet address
        let exploredAddress = EthereumAddress(address)! // Address which balance we want to know. Here we used same wallet address
        let erc20ContractAddress = EthereumAddress(_tokenAddress)!
        let contract = ehtNet.contract(Web3.Utils.erc20ABI, at: erc20ContractAddress, abiVersion: 2)!
        var options = TransactionOptions.defaultOptions
        options.from = walletAddress
        let method = "balanceOf"
        options.callOnBlock = .latest
        let tx = contract.read(
            method,
            parameters: [exploredAddress] as [AnyObject],
            extraData: Data(),
            transactionOptions: options)!
        let tokenBalance = try! tx.call()
        let balanceResult = tokenBalance["0"] as! BigUInt
        // balanceString = Web3.Utils.formatToPrecision(balanceResult)!
        balanceString = Web3.Utils.formatToEthereumUnits(balanceResult, toUnits: .wei, decimals: 0)!
        //balanceString = Web3.Utils.formatToEthereumUnits(balanceResult, toUnits: .eth, decimals: 3)
        return balanceString
    }
    
    func getGranted(address: String) -> String? {
        var balanceString : String!
        //let _tokenAddress:String = "0x553BE3CAAa3f7C2E30128EE0893378B104007082"
        
        let walletAddress = EthereumAddress(wallet.address)! // Your wallet address
        let exploredAddress = EthereumAddress(address)! // Address which balance we want to know. Here we used same wallet address
        let erc20ContractAddress = EthereumAddress(_tokenAddress)!
        let contract = ehtNet.contract(contractABI, at: erc20ContractAddress, abiVersion: 2)!
        //let abiVersion = 2 // Contract ABI version
        let parameters: [AnyObject] = [exploredAddress] as [AnyObject] // Parameters for contract method
        let extraData: Data = Data() // Extra data for contract method
        var options = TransactionOptions.defaultOptions
        options.from = walletAddress
        options.gasPrice = .automatic
        options.gasLimit = .automatic
        options.callOnBlock = .latest
        let method = "grantedOf"
        let tx = contract.read(
            method,
            parameters: parameters,
            extraData: extraData,
            transactionOptions: options)!
        let tokenBalance = try! tx.call()
        let balanceResult = tokenBalance["0"] as! BigUInt
        // balanceString = Web3.Utils.formatToPrecision(balanceResult)!
        balanceString = Web3.Utils.formatToEthereumUnits(balanceResult, toUnits: .wei, decimals: 0)!
        //balanceString = Web3.Utils.formatToEthereumUnits(balanceResult, toUnits: .eth, decimals: 3)
        return balanceString

    }
    
    func isMinter(address: String) -> Bool? {
        let walletAddress = EthereumAddress(wallet.address)! // Your wallet address
        let exploredAddress = EthereumAddress(address)! // Address which balance we want to know. Here we used same wallet address
        let erc20ContractAddress = EthereumAddress(_tokenAddress)!
        let contract = ehtNet.contract(contractABI, at: erc20ContractAddress, abiVersion: 2)!
        let parameters: [AnyObject] = [exploredAddress] as [AnyObject] // Parameters for contract method
        let extraData: Data = Data() // Extra data for contract method
        var options = TransactionOptions.defaultOptions
        options.from = walletAddress
        options.gasPrice = .automatic
        options.gasLimit = .automatic
        options.callOnBlock = .latest
        let method = "isMinter"
        let tx = contract.read(
            method,
            parameters: parameters,
            extraData: extraData,
            transactionOptions: options)!
        let ret = try! tx.call()
        let result = ret["0"] as! Bool
        return result
    }

    func sendGood(toAddress:String, value:String){
        let walletAddress = EthereumAddress(address)! // Your wallet address
        let toAddress = EthereumAddress(toAddress)!
        let erc20ContractAddress = EthereumAddress(_tokenAddress)!
        let contract = ehtNet.contract(Web3.Utils.erc20ABI, at: erc20ContractAddress, abiVersion: 2)!
        var options = TransactionOptions.defaultOptions
        options.from = walletAddress
        let method = "transfer"
        let tx = contract.write(
            method,
            parameters: [toAddress, value] as [AnyObject],
            extraData: Data(),
            transactionOptions: options)!
        let result = try! tx.send(password: password)
    }
    func addGood(toAddress:String, value:String){
        let walletAddress = EthereumAddress(address)! // Your wallet address
        let toAddress = EthereumAddress(toAddress)!
        let erc20ContractAddress = EthereumAddress(_tokenAddress)!
        let contract = ehtNet.contract(contractABI, at: erc20ContractAddress, abiVersion: 2)!
        var options = TransactionOptions.defaultOptions
        options.from = walletAddress
        options.callOnBlock = .latest
        let method = "mint"
        let tx = contract.write(
            method,
            parameters: [toAddress, value] as [AnyObject],
            extraData: Data(),
            transactionOptions: options)!
        let result = try! tx.send(password: password)
    }

}
