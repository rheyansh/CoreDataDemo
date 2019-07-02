//
//  Users+CoreDataProperties.swift
//  CoreDataDemo
//
//  Created by raj.sharma on 02/07/19.
//  Copyright © 2019 raj.sharma. All rights reserved.
//
//

import Foundation
import CoreData


extension Users {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Users> {
        return NSFetchRequest<Users>(entityName: "Users")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var password: String?
    @NSManaged public var username: String?
    @NSManaged public var book: Set<Book>?

}

// MARK: Generated accessors for book
extension Users {

    @objc(addBookObject:)
    @NSManaged public func addToBook(_ value: Book)

    @objc(removeBookObject:)
    @NSManaged public func removeFromBook(_ value: Book)

    @objc(addBook:)
    @NSManaged public func addToBook(_ values: NSSet)

    @objc(removeBook:)
    @NSManaged public func removeFromBook(_ values: NSSet)

}
