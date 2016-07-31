//
//  Run+CoreDataProperties.swift
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

extension Run {

    @NSManaged var distance: String?
    @NSManaged var runTime: String?
    @NSManaged var stallTime: String?
    @NSManaged var pace: String?
    @NSManaged var date: NSDate?
    @NSManaged var locations: NSOrderedSet?

}