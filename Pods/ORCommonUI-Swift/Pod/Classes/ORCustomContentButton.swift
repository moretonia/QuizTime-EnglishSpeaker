//
//  ORCustomContentButton.swift
//  Pods
//
//  Created by Maxim Soloviev on 11/08/16.
//  Copyright © 2016 Maxim Soloviev. All rights reserved.
//

import UIKit

open class ORCustomContentButton: UIControl {
    
    fileprivate var defaultAlphaForButton: CGFloat = 1.0
    
    @IBInspectable open var buttonHighlightedAlpha: CGFloat = 0.3
    @IBInspectable open var contentHighlightedAlpha: CGFloat = 1
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        isExclusiveTouch = true
        defaultAlphaForButton = alpha
        subviews.forEach({ $0.isUserInteractionEnabled = false })
    }
    
    open override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.1) {
                self.alpha = self.isHighlighted ? self.buttonHighlightedAlpha : self.defaultAlphaForButton
                self.subviews.forEach({ $0.alpha = self.isHighlighted ? self.contentHighlightedAlpha : 1 })
            }
        }
    }
}
