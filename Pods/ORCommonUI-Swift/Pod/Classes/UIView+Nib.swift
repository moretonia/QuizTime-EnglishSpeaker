//
//  UIView+Nib.swift
//  Pods
//
//  Created by Maxim Soloviev on 22/03/2017.
//  Copyright © 2017 Maxim Soloviev. All rights reserved.
//

import Foundation
import PureLayout

extension UIView {
    
    public static func or_loadFromNib() -> Self {
        return or_loadFromNib(owner: nil)
    }
    
    public static func or_loadFromNib(owner: AnyObject?) -> Self {
        let v = Bundle(for: self.classForCoder()).loadNibNamed(String(describing: self), owner: owner, options: nil)!.first
        return v as! Self
    }
    
    public static func or_loadFromNib(containerToFill: UIView) -> Self {
        return or_loadFromNib(containerToFill: containerToFill, owner: nil)
    }
    
    public static func or_loadFromNib(containerToFill: UIView, owner: AnyObject?) -> Self {
        let v = or_loadFromNib(owner: owner)
        v.translatesAutoresizingMaskIntoConstraints = false
        containerToFill.addSubview(v)
        v.autoPinEdgesToSuperviewEdges()
        return v
    }
}
