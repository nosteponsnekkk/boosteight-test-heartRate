//
//  Array+Ext.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 26.05.2024.
//

import Foundation

extension Array where Element: Hashable & BinaryInteger {
    func averageOfThreeMostFrequent() -> Element? {
        guard self.count >= 3 else {
            return nil
        }
        
        var frequencyDict: [Element: Int] = [:]
        
        for item in self {
            frequencyDict[item, default: 0] += 1
        }
        
        let sortedElements = frequencyDict.sorted { $0.value > $1.value }.prefix(3).map { $0.key }
        
        guard sortedElements.count == 3 else {
            return nil
        }
        
        let sum = sortedElements.reduce(0, +)
        let average = sum / Element(3)
        
        return average
    }
}
