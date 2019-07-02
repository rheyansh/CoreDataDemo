//
//  Book+CoreDataProperties.swift
//  CoreDataDemo
//
//  Created by raj.sharma on 02/07/19.
//  Copyright © 2019 raj.sharma. All rights reserved.
//
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var author: String?
    @NSManaged public var desc: String?
    @NSManaged public var publishedAt: Date?
    @NSManaged public var title: String?
    @NSManaged public var users: NSSet?

}

// MARK: Generated accessors for users
extension Book {

    @objc(addUsersObject:)
    @NSManaged public func addToUsers(_ value: Users)

    @objc(removeUsersObject:)
    @NSManaged public func removeFromUsers(_ value: Users)

    @objc(addUsers:)
    @NSManaged public func addToUsers(_ values: NSSet)

    @objc(removeUsers:)
    @NSManaged public func removeFromUsers(_ values: NSSet)

}
