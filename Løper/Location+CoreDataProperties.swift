//
//  Location+CoreDataProperties.swift
//  Løper
//
//  Created by Caleb Rudnicki on 7/18/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Location {

    @NSManaged var longitude: NSNumber?
    @NSManaged var latitude: NSNumber?
    @NSManaged var run: Run?

}