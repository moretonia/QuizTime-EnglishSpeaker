//
//  Array+Extended.swift
//  Pods
//
//  Created by Maxim Soloviev on 24/05/16.
//  Copyright © 2016 Maxim Soloviev. All rights reserved.
//

import Foundation

extension Array {
    
    public func or_limitedBySize(_ size: Int) -> [Element] {
        if (self.count <= size) {
            return self
        } else {
            return Array(self[0..<size])
        }
    }
}
