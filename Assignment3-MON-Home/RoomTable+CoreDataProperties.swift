//
//  RoomTable+CoreDataProperties.swift
//  Assignment3-MON-Home
//
//  Created by weicheng chen on 26/10/17.
//  Copyright © 2017 Minh&Weicheng. All rights reserved.
//
//

import Foundation
import CoreData


extension RoomTable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RoomTable> {
        return NSFetchRequest<RoomTable>(entityName: "RoomTable")
    }

    @NSManaged public var contains: NSOrderedSet?

    func addRoom(value: Room){
        let newRoom = self.mutableSetValue(forKey: "contains")
        newRoom.add(value)
    }
}

// MARK: Generated accessors for contains
extension RoomTable {

    @objc(insertObject:inContainsAtIndex:)
    @NSManaged public func insertIntoContains(_ value: Room, at idx: Int)

    @objc(removeObjectFromContainsAtIndex:)
    @NSManaged public func removeFromContains(at idx: Int)

    @objc(insertContains:atIndexes:)
    @NSManaged public func insertIntoContains(_ values: [Room], at indexes: NSIndexSet)

    @objc(removeContainsAtIndexes:)
    @NSManaged public func removeFromContains(at indexes: NSIndexSet)

    @objc(replaceObjectInContainsAtIndex:withObject:)
    @NSManaged public func replaceContains(at idx: Int, with value: Room)

    @objc(replaceContainsAtIndexes:withContains:)
    @NSManaged public func replaceContains(at indexes: NSIndexSet, with values: [Room])

    @objc(addContainsObject:)
    @NSManaged public func addToContains(_ value: Room)

    @objc(removeContainsObject:)
    @NSManaged public func removeFromContains(_ value: Room)

    @objc(addContains:)
    @NSManaged public func addToContains(_ values: NSOrderedSet)

    @objc(removeContains:)
    @NSManaged public func removeFromContains(_ values: NSOrderedSet)

}
