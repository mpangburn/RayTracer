//
//  CoreDataHelpers.swift
//  RayTracer-iOS
//
//  Created by Michael Pangburn on 7/7/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import CoreData


func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
    let container = NSPersistentContainer(name: "RayTracer")
    let description = NSPersistentStoreDescription()
    description.type = NSInMemoryStoreType
    container.persistentStoreDescriptions = [description]
    return container.viewContext
}
