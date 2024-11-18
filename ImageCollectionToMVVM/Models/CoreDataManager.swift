// CoreDataManager.swift
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ImageCollectionModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {}
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}

////
////  CoreDataManager.swift
////  ImageCollectionToMVVM
////
////  Created by Lydia Lu on 2024/11/18.
////
//
//import Foundation
//import CoreData
//import UIKit
//
//class CoreDataManager {
//    static let shared = CoreDataManager()
//    
//    lazy var persistentContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "ImageCollection")
//        container.loadPersistentStores { description, error in
//            if let error = error {
//                fatalError("Failed to load Core Data stack: \(error)")
//            }
//        }
//        return container
//    }()
//    
//    var context: NSManagedObjectContext {
//        return persistentContainer.viewContext
//    }
//    
//    func saveContext() {
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                print("Error saving context: \(error)")
//            }
//        }
//    }
//}
