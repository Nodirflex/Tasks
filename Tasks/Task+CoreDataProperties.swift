//
//  Task+CoreDataProperties.swift
//  Tasks
//
//  Created by user on 05.03.2021.
//  Copyright © 2021 user. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var item: String?

}
