//
//  HeartMeasurement.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 26.05.2024.
//

import Foundation
public struct HeartMeasurement {
    let date: Date
    let result: Int
    
    static let mockSlowData = HeartMeasurement(date: .now, result: 53)
    static let mockNormalData = HeartMeasurement(date: .now, result: 74)
    static let mockFastData = HeartMeasurement(date: .now, result: 105)

}
