//
//  Device+CoreDataProperties.swift
//  Assignment3-MON-Home
//
//  Created by weicheng chen on 26/10/17.
//  Copyright © 2017 Minh&Weicheng. All rights reserved.
//
//

import Foundation
import CoreData


extension Device {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Device> {
        return NSFetchRequest<Device>(entityName: "Device")
    }

    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var data: String?
    @NSManaged public var inRoom: Room?

}
