//
//  NSAttributedString+Extended.swift
//  Pods
//
//  Created by Alexander Kurbanov on 3/30/16.
//
//

import Foundation

extension NSAttributedString {
    
    public static func or_attrString(text: String, textColor: UIColor?, font: UIFont?, textAlign: NSTextAlignment = NSTextAlignment.center, lineBreakMode: NSLineBreakMode? = NSLineBreakMode.byWordWrapping, tightenLineSpacing: Bool = false, kerningValue: CGFloat?) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        
        if lineBreakMode != nil {
            paragraphStyle.lineBreakMode = lineBreakMode!
        }
        paragraphStyle.alignment = textAlign
        paragraphStyle.lineSpacing = 0
        var attr: [NSAttributedString.Key: Any] = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        if textColor != nil {
            attr[NSAttributedString.Key.foregroundColor] = textColor!
        }
        if font != nil {
            attr[NSAttributedString.Key.font] = font!
        }
        if tightenLineSpacing {
            paragraphStyle.maximumLineHeight = font!.pointSize
        }
        if kerningValue != nil {
            attr[NSAttributedString.Key.kern] = kerningValue!
        }
        
        let string = NSAttributedString(string: text, attributes: attr)
        return string
    }
    
    @objc public static func or_attrStringWithHyperlinks(original: String, attributes: [NSAttributedString.Key: Any] = [:]) -> NSAttributedString {
        let matches = original.or_matchesForRegexInText("\\[(.*?)\\]")
        if ((matches.count % 2) != 0 || matches.count == 0) {
            return NSAttributedString()
        }
        
        let result = NSMutableAttributedString()
        var beginIndex = 0
        let str = original as NSString
        for i in stride(from: 0, to: matches.count, by: 2) {
            let textRange = matches[i].range
            let text = str.substring(with: textRange)
        
            let valueRange = matches[i + 1].range
            let value = str.substring(with: valueRange)
            
            let normalText = NSAttributedString(string: str.substring(with: NSMakeRange(beginIndex, textRange.location - beginIndex)))
            result.append(normalText)
            
            let link = NSMutableAttributedString(string: text.or_withoutFirstAndLastChars())
            link.addAttribute(NSAttributedString.Key.link, value: value.or_withoutFirstAndLastChars(), range: NSMakeRange(0, link.length))
            result.append(link)
        
            beginIndex = valueRange.location + valueRange.length
        }
        let remainingText = NSAttributedString(string: str.substring(with: NSMakeRange(beginIndex, str.length - beginIndex)))
        result.append(remainingText)
        
        result.addAttributes(attributes, range: NSMakeRange(0, result.length))
        return result
    }
}
