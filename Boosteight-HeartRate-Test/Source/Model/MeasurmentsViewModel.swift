//
//  MeasurmentsViewModel.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 26.05.2024.
//

import Foundation
import Combine

public final class MeasurmentsViewModel: ObservableObject {
    @Published private var data: [HeartMeasurement] = []
    private var cancellables: Set<AnyCancellable> = []
    
    
    init(){
        Task { [weak self] in
            self?.loadData()
        }
    }
    
    private func loadData(){
        CoreDataManager.shared.readAllMeasurementEntities { [weak self] measuremets in
            self?.data = measuremets
        }
    }
}
extension MeasurmentsViewModel {
    public func bind(completion: @escaping (_ isDataEmpty: Bool) -> Void) {
        $data
            .receive(on: DispatchQueue.main)
            .sink() { completion($0.isEmpty) }
            .store(in: &cancellables)
    }
    public func createMeasurement(_ measurement: HeartMeasurement) {
        CoreDataManager.shared.createMeasurementEntity(measurement, completion: loadData)
        
    }
    public func deleteAllMeasurements(){
        CoreDataManager.shared.deleteAllMeasurementEntities(completion: loadData)
    }
    public var measurments: [HeartMeasurement] {
        return data.sorted { $0.date > $1.date }
    }
}
