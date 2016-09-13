//
//  Person+CoreDataProperties.swift
//  SimpleCoredataExample
//
//  Created by Flávio Silvério on 13/09/16.
//  Copyright © 2016 Flávio Silvério. All rights reserved.
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person");
    }

    @NSManaged public var name: String?

}
