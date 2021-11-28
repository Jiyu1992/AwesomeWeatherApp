//
//  MyCity+CoreDataProperties.swift
//  AwesomeWeatherApp
//
//  Created by Lefteris Mantas on 28/11/21.
//
//

import Foundation
import CoreData


extension MyCity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyCity> {
        return NSFetchRequest<MyCity>(entityName: "MyCity")
    }

    @NSManaged public var country: String?
    @NSManaged public var lat: Double
    @NSManaged public var localtime: String?
    @NSManaged public var localtimeEpoch: Int
    @NSManaged public var lon: Double
    @NSManaged public var name: String
    @NSManaged public var region: String?
    @NSManaged public var tzID: String?

}

extension MyCity : Identifiable {

}
