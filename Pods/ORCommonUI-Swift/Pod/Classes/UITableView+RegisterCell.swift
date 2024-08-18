//
//  UITableView+RegisterCell.swift
//  Pods
//
//  Created by Maxim Soloviev on 26/04/2017.
//
//

import UIKit

extension UITableView {

    open func or_registerCellNibs(forClasses cellClasses: AnyClass...) {
        cellClasses.forEach { self.or_registerCellNib(forClass: $0) }
    }

    open func or_registerCellNib(forClass cellClass: AnyClass) {
        let nib = UINib(nibName: String(describing: cellClass), bundle:nil)
        register(nib, forCellReuseIdentifier: String(describing: cellClass))
    }

    open func or_registerHeaderFooterNibs(forClasses headerFooterClasses: AnyClass...) {
        headerFooterClasses.forEach { self.or_registerHeaderFooterNib(forClass: $0) }
    }
    
    open func or_registerHeaderFooterNib(forClass headerFooterClass: AnyClass) {
        let nib = UINib(nibName: String(describing: headerFooterClass), bundle:nil)
        register(nib, forHeaderFooterViewReuseIdentifier: String(describing: headerFooterClass))
    }
}
