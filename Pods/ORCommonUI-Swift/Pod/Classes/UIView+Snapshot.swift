//
//  UIView+Snapshot.swift
//  Pods
//
//  Created by Dmitriy Mamatov on 31/01/17.
//
//

import UIKit

extension UIView {
    
    public var or_snapshot: UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
            layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return image
        }
    }
}
