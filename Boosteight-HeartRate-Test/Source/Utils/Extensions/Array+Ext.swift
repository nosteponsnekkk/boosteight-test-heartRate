//
//  Array+Ext.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 26.05.2024.
//

import Foundation
extension Array where Element: Hashable {
    func mostFrequent() -> Element? {
        guard !self.isEmpty else {
            return nil
        }
        
        var frequencyDict: [Element: Int] = [:]
        
        for item in self {
            frequencyDict[item, default: 0] += 1
        }
        
        let mostFrequentElement = frequencyDict.max { a, b in a.value < b.value }?.key
        
        return mostFrequentElement
    }
}
