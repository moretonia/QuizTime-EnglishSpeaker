//
//  ORAppInfo.swift
//  Pods
//
//  Created by Maxim Soloviev on 20/07/17.
//

import UIKit

open class ORAppInfo: NSObject {

    public static var name: String {
        if let text = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
            return text
        }
        
        let text = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""
        return text
    }

    public static var appVersion: String {
        let text = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
        return text
    }

    public static var updateDate: Date {
        guard let resPath = Bundle.main.resourcePath else {
            return Date()
        }
        let filePath = (resPath as NSString).appendingPathComponent("Info.plist")
        guard let attributesOfItem = try? FileManager.default.attributesOfItem(atPath: filePath) as NSDictionary, let modificationDate = attributesOfItem.fileModificationDate() else {
            return Date()
        }
        return modificationDate
    }

    public static func updateDate(fileName: String) -> Date {
        guard let resPath = Bundle.main.resourcePath else {
            return Date()
        }
        let filePath = (resPath as NSString).appendingPathComponent(fileName)
        guard let attributesOfItem = try? FileManager.default.attributesOfItem(atPath: filePath) as NSDictionary, let modificationDate = attributesOfItem.fileModificationDate() else {
            return Date()
        }
        return modificationDate
    }

    public static var size: UInt64 {
        let bundlePath = Bundle.main.bundlePath
        let bundleArray = try! FileManager.default.subpathsOfDirectory(atPath: bundlePath)
        var totalSize: UInt64 = 0
        
        for file in bundleArray {
            if let attributesOfItem = try? FileManager.default.attributesOfItem(atPath: (bundlePath as NSString).appendingPathComponent(file)) as NSDictionary {
                let fileSize = attributesOfItem.fileSize()
                totalSize += fileSize
            }
        }
        
        return totalSize
    }
}
