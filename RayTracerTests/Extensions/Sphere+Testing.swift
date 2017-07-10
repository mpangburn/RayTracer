//
//  Sphere+Testing.swift
//  RayTracer-iOS
//
//  Created by Michael Pangburn on 7/7/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import Foundation
import CoreData
import RayTracer


extension Sphere {
    convenience init(center: Point, radius: Double, color: Color = Color.black, finish: Finish = Finish.none, context: NSManagedObjectContext) {
        self.init(context: context)
        self.center = center
        self.radius = radius
        self.color = color
        self.finish = finish
    }
}

