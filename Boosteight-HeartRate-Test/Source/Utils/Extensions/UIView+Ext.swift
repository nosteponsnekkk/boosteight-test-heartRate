//
//  UIView+Ext.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 23.05.2024.
//

import UIKit
extension UIView {
    
    func startPulse(duration: TimeInterval = 0.75, fromValue: CGFloat = 1, toValue: CGFloat = 0.95) {
        let pulse = CABasicAnimation(keyPath: "transform.scale")
        pulse.duration = duration
        pulse.fromValue = fromValue
        pulse.toValue = toValue
        pulse.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        layer.add(pulse, forKey: "pulse")
    }
    
    func stopPulse() {
        layer.removeAnimation(forKey: "pulse")
    }
}
