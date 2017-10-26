//
//  WeatherLocation+CoreDataProperties.swift
//  Assignment3-MON-Home
//
//  Created by weicheng chen on 26/10/17.
//  Copyright © 2017 Minh&Weicheng. All rights reserved.
//
//

import Foundation
import CoreData


extension WeatherLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherLocation> {
        return NSFetchRequest<WeatherLocation>(entityName: "WeatherLocation")
    }

    @NSManaged public var name: String?

}
