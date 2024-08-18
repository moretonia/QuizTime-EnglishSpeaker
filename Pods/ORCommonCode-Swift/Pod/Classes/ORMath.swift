//
//  ORMath.swift
//  Pods
//
//  Created by Maxim Soloviev on 10/09/16.
//
//

import UIKit

@objc open class ORMath: NSObject {

    open class AverageValueCalculator: NSObject {
        private(set) open var avgValue: Double = 0
        private(set) open var valueCount = 0
        
        open func addValueAndReturnAverage(_ value: Double) -> Double {
            valueCount += 1
            
            avgValue = (avgValue * Double(valueCount - 1) + value) / Double(valueCount)
            return avgValue
        }
        
        open func addValue(_ value: Double) {
            _ = addValueAndReturnAverage(value)
        }
        
        open func reset() {
            avgValue = 0
            valueCount = 0
        }
    }

    // only static methods are available
    fileprivate override init() {
    }
    
    /**
     @param t: 0.0 - 1.0
     */
    @objc public static func lerp(_ a: CGFloat, _ b: CGFloat, _ t: CGFloat) -> CGFloat {
        let res = (a + (b - a) * t)
        return res
    }
    
    /**
     @param t: 0.0 - 1.0
     */
    @objc public static func cerp(_ a: CGFloat, _ b: CGFloat, _ t: CGFloat) -> CGFloat {
        let res = (a + (b - a) * pow(t, 3))
        return res
    }
    
    @objc public static func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let distance = hypot(a.x - b.x, a.y - b.y)
        return distance
    }
}
