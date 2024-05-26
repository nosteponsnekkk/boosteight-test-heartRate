//
//  HeartMeasurementEntity+CoreDataClass.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 26.05.2024.
//
//

import Foundation
import CoreData

@objc(HeartMeasurementEntity)
public class HeartMeasurementEntity: NSManagedObject {

}

extension HeartMeasurementEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HeartMeasurementEntity> {
        return NSFetchRequest<HeartMeasurementEntity>(entityName: "HeartMeasurementEntity")
    }

    @NSManaged public var result: Int64
    @NSManaged public var date: Date?

}

extension HeartMeasurementEntity : Identifiable {

}
