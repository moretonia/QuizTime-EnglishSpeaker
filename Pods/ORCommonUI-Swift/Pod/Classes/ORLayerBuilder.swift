//
//  ORLayerBuilder.swift
//  ORCommonUI-Swift
//
//  Created by Alexey Vedushev on 16/01/2019.
//

import Foundation

public class LayerBuilder {
    public static func getMaskLayer(rect: CGRect, cornerRadius: CGFloat) -> CAShapeLayer {
        let maskLayer = CAShapeLayer()
        
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        maskLayer.path = path.cgPath
        return maskLayer
    }
    
    public static func getBorderLayer(rect: CGRect, color: UIColor, cornerRadius: CGFloat, lineWidth: CGFloat) -> CAShapeLayer {
        let borderLayer = CAShapeLayer()
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        borderLayer.path = path.cgPath
        borderLayer.strokeColor = color.cgColor
        borderLayer.lineWidth = lineWidth
        borderLayer.fillColor = UIColor.clear.cgColor
        return borderLayer
    }
    
    public static func getDottedBorderLayer(_ rect: CGRect, color: UIColor, cornerRadius: CGFloat, lineDashPattern: [NSNumber] = [4, 4]) -> CAShapeLayer  {
        let border = CAShapeLayer()
        border.strokeColor = color.cgColor;
        border.fillColor = nil;
        border.lineDashPattern = lineDashPattern;
        border.path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
        border.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: rect.origin.y + rect.width, height: rect.origin.x + rect.height))
        return border
    }
}
