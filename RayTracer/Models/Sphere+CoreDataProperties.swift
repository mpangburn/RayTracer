//
//  Sphere+CoreDataProperties.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/8/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import Foundation
import CoreData


extension Sphere {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sphere> {
        return NSFetchRequest<Sphere>(entityName: "Sphere")
    }

    /// The center of the sphere.
    @NSManaged public var center: Point

    /// The radius of the sphere.
    @NSManaged public var radius: Double

    /// The color of the sphere.
    @NSManaged public var color: Color

    /// The finish of the sphere.
    @NSManaged public var finish: Finish

    /// The date of the sphere's creation.
    @NSManaged public var creationDate: NSDate

    override public func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = NSDate()
    }

}
