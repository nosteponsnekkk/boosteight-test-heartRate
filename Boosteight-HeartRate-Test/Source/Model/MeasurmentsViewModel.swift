//
//  MeasurmentsViewModel.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 26.05.2024.
//

import Foundation
import Combine

public final class MeasurmentsViewModel: ObservableObject {
    @Published private var data: [HeartMeasurement] = [
        .mockFastData,
        .mockNormalData,
        .mockSlowData,
        .mockFastData,
        .mockNormalData,
        .mockSlowData,
        .mockFastData,
        .mockNormalData,
        .mockSlowData,
        .mockFastData,
        .mockNormalData,
        .mockSlowData,
        .mockFastData,
        .mockNormalData,
        .mockSlowData
    ]
    private var cancellables: Set<AnyCancellable> = []
    
    
}
extension MeasurmentsViewModel {
    public func bind(completion: @escaping (_ isDataEmpty: Bool) -> Void) {
        $data
            .receive(on: DispatchQueue.main)
            .sink() { completion($0.isEmpty) }
            .store(in: &cancellables)
    }
    
    public var measurments: [HeartMeasurement] {
        return data.sorted { $0.date > $1.date }
    }
}
