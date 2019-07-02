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
    
    class func createBook(number: Int) {
        
        let entity = NSEntityDescription.entity(forEntityName: DBConstants.bookEntity, in: DBConstants.mainContext)
        let nwUser = NSManagedObject(entity: entity!, insertInto: DBConstants.mainContext)
        nwUser.setValue("Author \(number)", forKey: "author")
        nwUser.setValue("Desc \(number)", forKey: "desc")
        nwUser.setValue(Date(), forKey: "publishedAt")
        nwUser.setValue("title \(number)", forKey: "title")
        
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
    static let bookEntity = "Book"
    //static let mainContext = AppConstants.appDel.persistentContainer.viewContext
    
    //https://code.tutsplus.com/tutorials/core-data-and-swift-nsfetchedresultscontroller--cms-25072
    // MARK: Core Data Stack
//    lazy var managedObjectModel: NSManagedObjectModel = {
//        let modelURL = NSBundle.mainBundle().URLForResource("Done", withExtension: "momd")!
//        return NSManagedObjectModel(contentsOfURL: modelURL)!
//    }()
    
    static var mainContext: NSManagedObjectContext = {
        return AppConstants.appDel.persistentContainer.viewContext
    }()
    
    static var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        return AppConstants.appDel.persistentContainer.persistentStoreCoordinator
    }()
}

//https://medium.com/swiftcairo/avoiding-race-conditions-in-swift-9ccef0ec0b26

/*
 There are many operators we can use for comparison. In addition to = and ==, which are identical as far as Core Data is concerned, there's also >= and =>, <= and =>, != and <>, and > and <. I encourage you to experiment with these operators to learn how they affect the results of the fetch request.
 
 
 ==>The following predicate illustrates how we can use the >= operator to only fetch Person records with an age attribute greater than 30.
 
let predicate = NSPredicate(format: "%K >= %i", "age", 30)
 
 ==> We also have operators for string comparison, CONTAINS, LIKE, MATCHES, BEGINSWITH, and ENDSWITH. Let's fetch every Person record whose name CONTAINS the letter j.
 let predicate = NSPredicate(format: "%K CONTAINS %@", "first", "j")

 If you run the application, the array of results will be empty since the string comparison is case sensitive by default. We can change this by adding a modifier like so:
 let predicate = NSPredicate(format: "%K CONTAINS[c] %@", "first", "j")

 ==> You can also create compound predicates using the keywords AND, OR, and NOT. In the following example, we fetch every person whose first name contains the letter j and is younger than 30.
 
let predicate = NSPredicate(format: "%K CONTAINS[c] %@ AND %K < %i", "first", "j", "age", 30)
 
 ==> Predicates also make it very easy to fetch records based on their relationship. In the following example, we fetch every person whose father's name is equal to Bart.
 
 let predicate = NSPredicate(format: "%K == %@", "father.first", "Bart")

 The above predicate works as expected, because %K is a variable argument substitution for a key path, not just a key.
 

 */
