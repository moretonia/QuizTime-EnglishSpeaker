//
//  UIScrollView+KeyboardInsetHandler.swift
//  Pods
//
//  Created by Maxim Soloviev on 16/04/16.
//  Copyright © 2016 Maxim Soloviev. All rights reserved.
//

import UIKit

open class ORScrollViewKeyboardInsetHandler : UIView {
    
    var needToCancelKeyboardHiding = true
    fileprivate weak var scrollView: UIScrollView!
    
    init(scrollView: UIScrollView) {
        self.scrollView = scrollView
        
        super.init(frame: CGRect.zero)
        
        scrollView.addSubview(self)
        
        isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func notificationKeyboardWillShow(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let frameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let frame = frameValue.cgRectValue
                let kbSize = frame.size
                
                let currentInsets = scrollView.contentInset
                let contentInsets = UIEdgeInsets.init(top: currentInsets.top, left: currentInsets.left, bottom: kbSize.height, right: currentInsets.right)
                scrollView.contentInset = contentInsets
                scrollView.scrollIndicatorInsets = contentInsets
                needToCancelKeyboardHiding = true
            }
        }
    }
    
    @objc func notificationKeyboardWillHide(_ notification: Notification) {
        needToCancelKeyboardHiding = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.05) {
            guard self.needToCancelKeyboardHiding == false else { return }
            
            let animationDuration: Double = {
                if let userInfo = notification.userInfo, let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber {
                    return duration.doubleValue
                } else {
                    return 0.25
                }
            }()
            
            UIView.animate(withDuration: animationDuration - 0.05, animations: { [weak self] in
                if let scrollView = self?.scrollView {
                    let currentInsets = scrollView.contentInset
                    let contentInsets = UIEdgeInsets.init(top: currentInsets.top, left: currentInsets.left, bottom: 0, right: currentInsets.right)
                    scrollView.contentInset = contentInsets
                    scrollView.scrollIndicatorInsets = contentInsets
                }
            })
        }
    }
}

extension UIScrollView {
    
    public func or_enableKeyboardHandling() {
        _ = ORScrollViewKeyboardInsetHandler(scrollView: self)
    }
}
