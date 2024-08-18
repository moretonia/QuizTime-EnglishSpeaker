//
//  Comparable+Extended.swift
//  ORCommonCode-Swift
//
//  Created by Sergey Aleksandrov on 09/01/2019.
//

extension Comparable {
    
    public func clamp(_ lower: Self, _ upper: Self) -> Self {
        return min(max(self, lower), upper)
    }
}
