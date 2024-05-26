//
//  PulseDetector.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 26.05.2024.
//

import Foundation
import QuartzCore

private let maxPeriodsToStore = 20
private let averageSize = 20
private let invalidPulsePeriod = -1
private let maxPeriod = 1.5
private let minPeriod = 0.1
private let invalidEntry: Double = -100

class PulseDetector {
    private var upVals = [Double](repeating: 0.0, count: averageSize)
    private var downVals = [Double](repeating: 0.0, count: averageSize)
    private var upValIndex = 0
    private var downValIndex = 0
    private var lastVal: Float = 0.0
    private var periods = [Double](repeating: 0.0, count: maxPeriodsToStore)
    private var periodTimes = [Double](repeating: 0.0, count: maxPeriodsToStore)
    private var periodIndex = 0
    private var started = false
    private var freq: Float = 0.0
    private var average: Float = 0.0
    private var wasDown = false

    private var periodStart: Double = 0.0

    func addNewValue(newVal: Double, atTime time: Double) {
        if newVal > 0 {
            upVals[upValIndex] = newVal
            upValIndex += 1
            if upValIndex >= averageSize {
                upValIndex = 0
            }
        }
        
        if newVal < 0 {
            downVals[downValIndex] = -newVal
            downValIndex += 1
            if downValIndex >= averageSize {
                downValIndex = 0
            }
        }
        
        // Calculate average values above and below zero
        let averageUp = upVals.reduce(0, +) / Double(averageSize)
        let averageDown = downVals.reduce(0, +) / Double(averageSize)
        
        if newVal < -0.5 * averageDown {
            wasDown = true
        }
        
        // Check for transition from down to up state
        if newVal >= 0.5 * averageUp && wasDown {
            wasDown = false
            let period = time - periodStart
            if period < maxPeriod && period > minPeriod {
                periods[periodIndex] = period
                periodTimes[periodIndex] = time
                periodIndex = (periodIndex + 1) % maxPeriodsToStore
            }
            periodStart = time
        }
        
    }

    func getAverage() -> Float {
        let time = CACurrentMediaTime()
        let validPeriods = periods.filter { period in
            return period != 0 && time - periodStart < 10
        }
        if validPeriods.count > 2 {
            let averagePeriod = validPeriods.reduce(0, +) / Double(validPeriods.count)
            return Float(averagePeriod)
        }
        return Float(invalidPulsePeriod)
    }

    func reset() {
        periods = [Double](repeating: 0.0, count: maxPeriodsToStore)
        upVals = [Double](repeating: 0.0, count: averageSize)
        downVals = [Double](repeating: 0.0, count: averageSize)
        freq = 0.5
        periodIndex = 0
        downValIndex = 0
        upValIndex = 0
    }
}
