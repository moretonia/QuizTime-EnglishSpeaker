//
//  Data+Extended.swift
//  Pods
//
//  Created by Maxim Soloviev on 06/02/2017.
//
//

import Foundation

extension Data {
    
    public func or_string() -> String {
        var str: String = ""
        for i in 0..<self.count {
            str += String(format: "%02.2hhx", self[i] as CVarArg)
        }
        return str
    }
}
