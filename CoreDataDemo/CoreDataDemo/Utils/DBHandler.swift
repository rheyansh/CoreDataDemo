//
//  DBHandler.swift
//  CoreDataDemo
//
//  Created by raj.sharma on 28/06/19.
//  Copyright © 2019 raj.sharma. All rights reserved.
//

import UIKit
import CoreData

class DBHandler: NSObject {
    
    class func createUser(username: String, password: String) {
        
        let entity = NSEntityDescription.entity(forEntityName: DBConstants.userEntity, in: DBConstants.mainContext)
        let nwUser = NSManagedObject(entity: entity!, insertInto: DBConstants.mainContext)
        nwUser.setValue(username, forKey: "username")
        nwUser.setValue(password, forKey: "password")
        nwUser.setValue(Date(), forKey: "createdAt")

        saveContext()
    }
    
    class func delete(_ item: NSManagedObject) {
        DBConstants.mainContext.delete(item)
        saveContext()
    }
    
    class func deleteAllUsers() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DBConstants.userEntity)
        deleteFetchRequest(fetchRequest)
    }
    
    class func deleteUsersWithName(_ name: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DBConstants.userEntity)
        fetchRequest.predicate = NSPredicate(format: "username = %@", name)
        deleteFetchRequest(fetchRequest)
    }
    
    class func deleteFetchRequest(_ request: NSFetchRequest<NSFetchRequestResult>) {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try DBConstants.persistentStoreCoordinator.execute(deleteRequest, with: DBConstants.mainContext)
        } catch let error as NSError {
            print("error on deleting request: \(error)")
        }
    }
    
    class func fetchUsers(_ callBack: ((Array<Users>?, Error?) -> ())?) {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: DBConstants.userEntity)

        /*
         request.predicate = NSPredicate(format: "age = %@", "12")

         let predicate = NSPredicate(format: "name CONTAINS[c] %@", "o")
         fetchRequest.predicate = predicate
         let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
         fetchRequest.sortDescriptors = [sortDescriptor]
         
         // Add Predicate
         let predicate1 = NSPredicate(format: "completed = 1")
         let predicate2 = NSPredicate(format: "%K = %@", "list.name", "Home")
         fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])

         let sortDescriptor = NSSortDescriptor(key: "username", ascending: true)
        let sortDescriptors = [sortDescriptor]
        request.sortDescriptors = sortDescriptors

        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
        let sortDescriptors = [sortDescriptor]
        request.sortDescriptors = sortDescriptors*/

        do {
            let result = try DBConstants.mainContext.fetch(request)
            if let users = result as? [Users] { callBack?(users, nil) }
        } catch let error {
            print("Failed")
            callBack?(nil, error)
        }
    }
    
    class func saveContext() {
        
        let context = DBConstants.mainContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Failed saving: Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

struct DBConstants {
    static let userEntity = "Users"
    static let mainContext = AppConstants.appDel.persistentContainer.viewContext
    static let persistentStoreCoordinator = AppConstants.appDel.persistentContainer.persistentStoreCoordinator
}

//lazy var mainContext: NSManagedObjectContext = {
//return AppConstants.appDel.persistentContainer.viewContext
//}()
//https://medium.com/@abhimuralidharan/lazy-var-in-ios-swift-96c75cb8a13a
//https://medium.com/swiftcairo/avoiding-race-conditions-in-swift-9ccef0ec0b26
