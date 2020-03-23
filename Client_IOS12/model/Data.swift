/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Helpers for loading images and data.
*/

import Foundation
import CoreLocation
import UIKit
import SwiftUI

var employeeMaster: [Employee] = load("EmployeeData.json")
//var me: Employee = employeeData[0]

func load<T: Decodable>(_ filename: String) -> T {
    let request = URL(string: "https://goodpoint-master-webapi.azurewebsites.net/users")!
    let file:URL = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] + filename)
    var rawData = try? Data(contentsOf: file)
    var serverData: Data?
    let semaphore = DispatchSemaphore(value: 0)
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        if error == nil {
            // let session = URLSession(configuration: .default)
            serverData = data
        }
        semaphore.signal()
        return
    }.resume()

    semaphore.wait()
    
    if serverData != nil {
        rawData = serverData
        do {
            try rawData!.write(to: file)
        } catch {
            fatalError("Couldn't flash \(filename) to local cache.")
        }
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: rawData!)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

final class ImageStore {
    typealias _ImageDictionary = [String: CGImage]
    fileprivate var images: _ImageDictionary = [:]

    fileprivate static var scale = 2
    
    static var shared = ImageStore()
    
    func image(name: String) -> UIImage {
        let index = _guaranteeImage(name: name)
    
        return UIImage(cgImage:images.values[index], scale: CGFloat(ImageStore.scale),orientation: .up)
    }

    static func loadImage(name: String) -> CGImage {
        guard
            let url = Bundle.main.url(forResource: name, withExtension: "jpg"),
            let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
            let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
        else {
            fatalError("Couldn't load image \(name).jpg from main bundle.")
        }
        return image
    }
    
    fileprivate func _guaranteeImage(name: String) -> _ImageDictionary.Index {
        if let index = images.index(forKey: name) { return index }
        
        images[name] = ImageStore.loadImage(name: name)
        return images.index(forKey: name)!
    }
}

