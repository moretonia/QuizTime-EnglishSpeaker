//
//  UICollectionView+RegisterCell.swift
//  Pods
//
//  Created by Maxim Soloviev on 26/04/2017.
//
//

import UIKit

extension UICollectionView {
    
    open func or_registerCellNibs(forClasses cellClasses: AnyClass...) {
        cellClasses.forEach { self.or_registerCellNib(forClass: $0) }
    }

    open func or_registerCellNib(forClass cellClass: AnyClass) {
        let nib = UINib(nibName: String(describing: cellClass), bundle:nil)
        register(nib, forCellWithReuseIdentifier: String(describing: cellClass))
    }
}
