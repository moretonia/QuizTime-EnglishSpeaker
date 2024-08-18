//
//  ORKeyboardLayoutConstraint.swift
//  Pods
//
//  Created by Maxim Soloviev on 10/08/16.
//  Copyright © 2016 Maxim Soloviev. All rights reserved.
//

import UIKit

open class ORKeyboardLayoutConstraint: NSLayoutConstraint {
    
    fileprivate var kKeyCalculatedConstant: String = ""
    open var originalOffset: CGFloat = 0
    
    @IBInspectable var useCustomOffsetWhenKeyboardIsShown: Bool = false
    @IBInspectable var customOffset: CGFloat = 0
    
    // MARK: - Object lifecycle
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        originalOffset = constant
        kKeyCalculatedConstant = "KeyCalculatedConstant"
        NotificationCenter.default.addObserver(self, selector: #selector(notificationKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - NSNotification methods
    
    @objc func notificationKeyboardWillShow(_ notification: Notification) {
        if var userInfo = (notification as NSNotification).userInfo {
            if let frameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let frame = frameValue.cgRectValue
                let offset = useCustomOffsetWhenKeyboardIsShown ? customOffset : originalOffset
                let calculatedConstant = frame.size.height + offset
                
                if calculatedConstant != constant {
                    userInfo[kKeyCalculatedConstant] = calculatedConstant
                    updateLayout(userInfo)
                }
            }
        }
    }
    
    @objc func notificationKeyboardWillHide(_ notification: Notification) {
        if var userInfo = notification.userInfo {
            userInfo[kKeyCalculatedConstant] = originalOffset
            updateLayout(userInfo)
        }
    }
    
    func updateLayout(_ userInfo: [AnyHashable: Any]) {
        if let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber, let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber, let constant = userInfo[kKeyCalculatedConstant] as? CGFloat {
            self.constant = constant
            
            UIView.animate(
                withDuration: TimeInterval(duration.doubleValue),
                delay: 0,
                options: UIView.AnimationOptions(rawValue: curve.uintValue),
                animations: {
                    var topView: UIView
                    if let s = self.firstItem?.superview, s != nil {
                        topView = s!
                    } else if let s = self.secondItem?.superview, s != nil {
                        topView = s!
                    } else {
                        print("ORKeyboardLayoutConstraint error: superview wasn't found!")
                        return
                    }
                    
                    while let superview = topView.superview , !(superview is UIWindow) {
                        topView = superview
                    }
                    topView.layoutIfNeeded()
            },
                completion: nil)
        }
    }
}

