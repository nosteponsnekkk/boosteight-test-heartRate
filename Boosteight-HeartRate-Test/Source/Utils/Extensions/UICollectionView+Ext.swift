//
//  UICollectionView+Ext.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 24.05.2024.
//

import UIKit
extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_ class: T.Type) {
        register(T.self, forCellWithReuseIdentifier: String(describing: `class`))
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(withClass class: T.Type,
                                                      for indexPath: IndexPath) -> T
    {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: `class`), for: indexPath) as? T else {
            fatalError()
        }
        return cell
    }
    
}
