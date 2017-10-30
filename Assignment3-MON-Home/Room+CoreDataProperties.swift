//
//  Room+CoreDataProperties.swift
//  Assignment3-MON-Home
//
//  Created by weicheng chen on 30/10/17.
//  Copyright © 2017 Minh&Weicheng. All rights reserved.
//
//

import Foundation
import CoreData


extension Room {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Room> {
        return NSFetchRequest<Room>(entityName: "Room")
    }

    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var hasDevices: NSOrderedSet?

}

// MARK: Generated accessors for hasDevices
extension Room {

    @objc(insertObject:inHasDevicesAtIndex:)
    @NSManaged public func insertIntoHasDevices(_ value: Device, at idx: Int)

    @objc(removeObjectFromHasDevicesAtIndex:)
    @NSManaged public func removeFromHasDevices(at idx: Int)

    @objc(insertHasDevices:atIndexes:)
    @NSManaged public func insertIntoHasDevices(_ values: [Device], at indexes: NSIndexSet)

    @objc(removeHasDevicesAtIndexes:)
    @NSManaged public func removeFromHasDevices(at indexes: NSIndexSet)

    @objc(replaceObjectInHasDevicesAtIndex:withObject:)
    @NSManaged public func replaceHasDevices(at idx: Int, with value: Device)

    @objc(replaceHasDevicesAtIndexes:withHasDevices:)
    @NSManaged public func replaceHasDevices(at indexes: NSIndexSet, with values: [Device])

    @objc(addHasDevicesObject:)
    @NSManaged public func addToHasDevices(_ value: Device)

    @objc(removeHasDevicesObject:)
    @NSManaged public func removeFromHasDevices(_ value: Device)

    @objc(addHasDevices:)
    @NSManaged public func addToHasDevices(_ values: NSOrderedSet)

    @objc(removeHasDevices:)
    @NSManaged public func removeFromHasDevices(_ values: NSOrderedSet)

}
