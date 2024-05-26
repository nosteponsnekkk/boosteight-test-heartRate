//
//  Date+Ext.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 26.05.2024.
//

import Foundation
extension Date {
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm\ndd/MM/yyyy"
        return formatter.string(from: self)
    }
}
