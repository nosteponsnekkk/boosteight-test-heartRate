//
//  CoreDataManager.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 26.05.2024.
//

import CoreData
import Foundation

//MARK: - Constants for CoreData Manager
fileprivate struct CoreDataConstants {
    static let dataBase_name        = "CoreDataModel"
    static let measurementEntity_name = "HeartMeasurementEntity"
}

//MARK: - CoreData Manager
public final class CoreDataManager {
    
    public static let shared = CoreDataManager()
    private init(){}
    
    private lazy var mainContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    private lazy var backgroundContext: NSManagedObjectContext = {
        return persistentContainer.newBackgroundContext()
    }()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataConstants.dataBase_name)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("❌ Unresolved error \(error)")
            }
        }
        return container
    }()
    
    private func saveBackgroundContext() {
        
        do {
            try backgroundContext.save()
            mainContext.performAndWait {
                do {
                    try mainContext.save()
                } catch {
                    print("⚠️ CoreData Save Main Context Error: \(error.localizedDescription)")
                }
            }
        } catch {
            print("⚠️ CoreData Save Background Context Error: \(error.localizedDescription)")
        }
    }
    
    
    
}

//MARK: - CRUD
extension CoreDataManager {
    
    //MARK: Create
    public func createMeasurementEntity(_ model: HeartMeasurement?, completion: @escaping () -> Void){
        guard let model else { return }
        backgroundContext.perform { [weak self] in
            guard let self else { return }
            if let entityDescription = NSEntityDescription.entity(forEntityName: CoreDataConstants.measurementEntity_name, in: backgroundContext) {
                let entity = HeartMeasurementEntity(entity: entityDescription, insertInto: backgroundContext)
                
                entity.result = Int64(model.result)
                entity.date = model.date
                
                saveBackgroundContext()
                completion()
            } else {
                print("⚠️ CoreData creating error: entity description is nil")
            }
        }
    }
    
    //MARK: Read
    public func readAllMeasurementEntities(completion: @escaping (_ measuremets : [HeartMeasurement]) -> Void) {
        backgroundContext.perform { [weak self] in
            guard let self else { completion([]) ; return }
            
            let fetchRequest = NSFetchRequest<HeartMeasurementEntity>(entityName: CoreDataConstants.measurementEntity_name)
            
            do {
                let result = try backgroundContext.fetch(fetchRequest)
                completion(result.map({ HeartMeasurement($0) }))
                return
            } catch {
                print("⚠️ CoreData reading error: \(error.localizedDescription)")
                completion([]) ; return
            }
        }
    }
        
    //MARK: Delete
    public func deleteAllMeasurementEntities(completion: @escaping () -> Void){
        backgroundContext.perform { [weak self] in
            guard let self else { return }
            let fetchRequest = NSFetchRequest<HeartMeasurementEntity>(entityName: CoreDataConstants.measurementEntity_name)
            
            do {
                let result = try backgroundContext.fetch(fetchRequest)
                result.forEach { self.backgroundContext.delete($0) }
                saveBackgroundContext()
                completion()
            } catch {
                print("⚠️ CoreData deleting error: \(error.localizedDescription)")
                return
            }
            
        }
    }
    
}
