//
//  UIFont+Ext.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 22.05.2024.
//

import UIKit
public extension UIFont {
    static func rubikSemiBold(ofSize size: CGFloat) -> UIFont? {
        UIFont.init(name: "Rubik-SemiBold", size: size)
    }
    static func rubikRegular(ofSize size: CGFloat) -> UIFont? {
        UIFont.init(name: "Rubik-Regular", size: size)
    }
}
