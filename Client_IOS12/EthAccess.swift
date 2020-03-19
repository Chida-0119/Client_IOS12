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
    private let contractABI = """
[
      {
        "inputs": [],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "constructor"
      },
      {
        "anonymous": false,
        "inputs": [
          {
            "indexed": true,
            "internalType": "address",
            "name": "owner",
            "type": "address"
          },
          {
            "indexed": true,
            "internalType": "address",
            "name": "spender",
            "type": "address"
          },
          {
            "indexed": false,
            "internalType": "uint256",
            "name": "value",
            "type": "uint256"
          }
        ],
        "name": "Approval",
        "type": "event"
      },
      {
        "anonymous": false,
        "inputs": [
          {
            "indexed": true,
            "internalType": "address",
            "name": "from",
            "type": "address"
          },
          {
            "indexed": true,
            "internalType": "address",
            "name": "to",
            "type": "address"
          },
          {
            "indexed": false,
            "internalType": "uint256",
            "name": "value",
            "type": "uint256"
          }
        ],
        "name": "Grant",
        "type": "event"
      },
      {
        "anonymous": false,
        "inputs": [
          {
            "indexed": true,
            "internalType": "address",
            "name": "account",
            "type": "address"
          }
        ],
        "name": "MinterAdded",
        "type": "event"
      },
      {
        "anonymous": false,
        "inputs": [
          {
            "indexed": true,
            "internalType": "address",
            "name": "account",
            "type": "address"
          }
        ],
        "name": "MinterRemoved",
        "type": "event"
      },
      {
        "anonymous": false,
        "inputs": [
          {
            "indexed": true,
            "internalType": "address",
            "name": "from",
            "type": "address"
          },
          {
            "indexed": true,
            "internalType": "address",
            "name": "to",
            "type": "address"
          },
          {
            "indexed": false,
            "internalType": "uint256",
            "name": "value",
            "type": "uint256"
          }
        ],
        "name": "Revoke",
        "type": "event"
      },
      {
        "anonymous": false,
        "inputs": [
          {
            "indexed": true,
            "internalType": "address",
            "name": "from",
            "type": "address"
          },
          {
            "indexed": true,
            "internalType": "address",
            "name": "to",
            "type": "address"
          },
          {
            "indexed": false,
            "internalType": "uint256",
            "name": "value",
            "type": "uint256"
          }
        ],
        "name": "Transfer",
        "type": "event"
      },
      {
        "constant": false,
        "inputs": [
          {
            "internalType": "address",
            "name": "account",
            "type": "address"
          }
        ],
        "name": "addMinter",
        "outputs": [],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "constant": true,
        "inputs": [
          {
            "internalType": "address",
            "name": "owner",
            "type": "address"
          },
          {
            "internalType": "address",
            "name": "spender",
            "type": "address"
          }
        ],
        "name": "allowance",
        "outputs": [
          {
            "internalType": "uint256",
            "name": "",
            "type": "uint256"
          }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
      },
      {
        "constant": false,
        "inputs": [
          {
            "internalType": "address",
            "name": "spender",
            "type": "address"
          },
          {
            "internalType": "uint256",
            "name": "amount",
            "type": "uint256"
          }
        ],
        "name": "approve",
        "outputs": [
          {
            "internalType": "bool",
            "name": "",
            "type": "bool"
          }
        ],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "constant": true,
        "inputs": [
          {
            "internalType": "address",
            "name": "account",
            "type": "address"
          }
        ],
        "name": "balanceOf",
        "outputs": [
          {
            "internalType": "uint256",
            "name": "",
            "type": "uint256"
          }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
      },
      {
        "constant": false,
        "inputs": [
          {
            "internalType": "uint256",
            "name": "amount",
            "type": "uint256"
          }
        ],
        "name": "burn",
        "outputs": [],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "constant": false,
        "inputs": [
          {
            "internalType": "address",
            "name": "account",
            "type": "address"
          },
          {
            "internalType": "uint256",
            "name": "amount",
            "type": "uint256"
          }
        ],
        "name": "burnFrom",
        "outputs": [],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "constant": true,
        "inputs": [],
        "name": "decimals",
        "outputs": [
          {
            "internalType": "uint8",
            "name": "",
            "type": "uint8"
          }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
      },
      {
        "constant": false,
        "inputs": [
          {
            "internalType": "address",
            "name": "spender",
            "type": "address"
          },
          {
            "internalType": "uint256",
            "name": "subtractedValue",
            "type": "uint256"
          }
        ],
        "name": "decreaseAllowance",
        "outputs": [
          {
            "internalType": "bool",
            "name": "",
            "type": "bool"
          }
        ],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "constant": false,
        "inputs": [
          {
            "internalType": "address",
            "name": "spender",
            "type": "address"
          },
          {
            "internalType": "uint256",
            "name": "addedValue",
            "type": "uint256"
          }
        ],
        "name": "increaseAllowance",
        "outputs": [
          {
            "internalType": "bool",
            "name": "",
            "type": "bool"
          }
        ],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "constant": true,
        "inputs": [
          {
            "internalType": "address",
            "name": "account",
            "type": "address"
          }
        ],
        "name": "isMinter",
        "outputs": [
          {
            "internalType": "bool",
            "name": "",
            "type": "bool"
          }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
      },
      {
        "constant": true,
        "inputs": [],
        "name": "name",
        "outputs": [
          {
            "internalType": "string",
            "name": "",
            "type": "string"
          }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
      },
      {
        "constant": false,
        "inputs": [],
        "name": "renounceMinter",
        "outputs": [],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "constant": true,
        "inputs": [],
        "name": "symbol",
        "outputs": [
          {
            "internalType": "string",
            "name": "",
            "type": "string"
          }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
      },
      {
        "constant": true,
        "inputs": [],
        "name": "totalSupply",
        "outputs": [
          {
            "internalType": "uint256",
            "name": "",
            "type": "uint256"
          }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
      },
      {
        "constant": false,
        "inputs": [
          {
            "internalType": "address",
            "name": "sender",
            "type": "address"
          },
          {
            "internalType": "address",
            "name": "recipient",
            "type": "address"
          },
          {
            "internalType": "uint256",
            "name": "amount",
            "type": "uint256"
          }
        ],
        "name": "transferFrom",
        "outputs": [
          {
            "internalType": "bool",
            "name": "",
            "type": "bool"
          }
        ],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "constant": true,
        "inputs": [],
        "name": "totalGranted",
        "outputs": [
          {
            "internalType": "uint256",
            "name": "",
            "type": "uint256"
          }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
      },
      {
        "constant": true,
        "inputs": [
          {
            "internalType": "address",
            "name": "account",
            "type": "address"
          }
        ],
        "name": "grantedOf",
        "outputs": [
          {
            "internalType": "uint256",
            "name": "",
            "type": "uint256"
          }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
      },
      {
        "constant": false,
        "inputs": [
          {
            "internalType": "address",
            "name": "account",
            "type": "address"
          },
          {
            "internalType": "uint256",
            "name": "amount",
            "type": "uint256"
          }
        ],
        "name": "revoke",
        "outputs": [
          {
            "internalType": "bool",
            "name": "",
            "type": "bool"
          }
        ],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "constant": false,
        "inputs": [
          {
            "internalType": "address",
            "name": "account",
            "type": "address"
          },
          {
            "internalType": "uint256",
            "name": "amount",
            "type": "uint256"
          }
        ],
        "name": "mint",
        "outputs": [
          {
            "internalType": "bool",
            "name": "",
            "type": "bool"
          }
        ],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "constant": false,
        "inputs": [
          {
            "internalType": "address",
            "name": "recipient",
            "type": "address"
          },
          {
            "internalType": "uint256",
            "name": "amount",
            "type": "uint256"
          }
        ],
        "name": "transfer",
        "outputs": [
          {
            "internalType": "bool",
            "name": "",
            "type": "bool"
          }
        ],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
      }
    ]
"""
    private var endpoint  = "http://ethjpgzfv-dns-reg1.japaneast.cloudapp.azure.com:8540"
    //let endpoint  = "http://23.102.73.125:8540"
    //private var endpoint  = "http://127.0.0.1:7545"
    fileprivate var provider : web3swift.Web3Provider
    private var ehtNet : web3
    private let password = "web3swift"
    private var wallet: Wallet
    //private let privatekey = "67d6b6fdb373ac2d054e369c0debd0aba03ab6ded4299f0c81ec2bcae5f67070" // Some private key
    //private let address : String = "0x6b0eEa30d84F0B88e07d7c649e3D0cbe8D3F15c3"
    private var privatekey : String = ""
    private var address : String = ""
    var _tokenAddress:String = "0x36F1A9af6458aCe117154eA854FE783f2000234D"
    // var _tokenAddress:String = "0x08b8916824BFD9D9E008273F82D15c59F30b5187" // on Azure
    
    mutating private func _setConnectConfig(con: ConnectConfig) {
             self.endpoint = con.destination.endpoint
             self._tokenAddress = con.destination.tokenAddress
             let formattedKey = privatekey.trimmingCharacters(in: .whitespacesAndNewlines)
             let dataKey = Data.fromHex(formattedKey)!
             let keystore = try! EthereumKeystoreV3(privateKey: dataKey, password: password)!
             // let keystore = try! BIP32Keystore(seed: dataKey, password: password)!
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
    
    init(con:ConnectConfig, prof: MyProfile) {
        self.privatekey = prof.me.privateKey
        self.address = prof.me.address
        self.endpoint = con.destination.endpoint
        self._tokenAddress = con.destination.tokenAddress
        let formattedKey = privatekey.trimmingCharacters(in: .whitespacesAndNewlines)
        let dataKey = Data.fromHex(formattedKey)!
        let keystore = try! EthereumKeystoreV3(privateKey: dataKey, password: password)!
        // let keystore = try! BIP32Keystore(seed: dataKey, password: password)!
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
        //let web3 = try! Web3.new(URL.init(string: endpoint)!)
        //let a : URLSessionConfiguration = web3.session.configuration

        //allAddresses = try! web3(provider: provider!).eth.getAccounts()
        
    }
    
    mutating func changeWallet(address:String, privateKey:String ) -> Bool {
             self.privatekey = privateKey
             self.address = address
             let formattedKey = privatekey.trimmingCharacters(in: .whitespacesAndNewlines)
             let dataKey = Data.fromHex(formattedKey)!
             let keystore = try! EthereumKeystoreV3(privateKey: dataKey, password: password)!
             //let keystore = try! BIP32Keystore(seed: dataKey, password: password)!
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
        //let _tokenAddress:String = "0x553BE3CAAa3f7C2E30128EE0893378B104007082"
        
        let walletAddress = EthereumAddress(wallet.address)! // Your wallet address
        let exploredAddress = EthereumAddress(address)! // Address which balance we want to know. Here we used same wallet address
        let erc20ContractAddress = EthereumAddress(_tokenAddress)!
        let contract = ehtNet.contract(Web3.Utils.erc20ABI, at: erc20ContractAddress, abiVersion: 2)!
        var options = TransactionOptions.defaultOptions
        options.from = walletAddress
        //options.gasPrice = .automatic
        //options.gasLimit = .automatic
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
        //options.to = erc20ContractAddress
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
        //options.to = erc20ContractAddress
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
        //let value: String = "1.0" // In Tokens
        let walletAddress = EthereumAddress(address)! // Your wallet address
        let toAddress = EthereumAddress(toAddress)!
        let erc20ContractAddress = EthereumAddress(_tokenAddress)!
        let contract = ehtNet.contract(Web3.Utils.erc20ABI, at: erc20ContractAddress, abiVersion: 2)!
        //let amount = Web3.Utils.parseToBigUInt(value, units: .eth)
        //let amount = Web3.Utils.parseToBigUInt(value, decimals: 0)
        var options = TransactionOptions.defaultOptions
        //options.value = amount
        options.from = walletAddress
        //options.gasPrice = .automatic
        //options.gasLimit = .automatic
        let method = "transfer"
        let tx = contract.write(
            method,
            parameters: [toAddress, value] as [AnyObject],
            extraData: Data(),
            transactionOptions: options)!
        let result = try! tx.send(password: password)
    }
    func addGood(toAddress:String, value:String){
        //let value: String = "1.0" // In Tokens
        let walletAddress = EthereumAddress(address)! // Your wallet address
        let toAddress = EthereumAddress(toAddress)!
        let erc20ContractAddress = EthereumAddress(_tokenAddress)!
        let contract = ehtNet.contract(contractABI, at: erc20ContractAddress, abiVersion: 2)!
        //let amount = Web3.Utils.parseToBigUInt(value, units: .eth)
        //let amount = Web3.Utils.parseToBigUInt(value, decimals: 0)
        var options = TransactionOptions.defaultOptions
        //options.value = amount
        options.from = walletAddress
        options.callOnBlock = .latest
        //options.gasPrice = .automatic
        //options.gasLimit = .automatic
        let method = "mint"
        let tx = contract.write(
            method,
            parameters: [toAddress, value] as [AnyObject],
            extraData: Data(),
            transactionOptions: options)!
        let result = try! tx.send(password: password)
    }

}
