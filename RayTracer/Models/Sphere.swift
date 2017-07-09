//
//  Sphere.swift
//  RayTracer
//
//  Created by Michael Pangburn on 6/26/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import Foundation
import CoreData


/// Represents a sphere.
extension Sphere {

    /**
     Creates a sphere with the given center, radius, and color.
     - Parameters:
        - center: The center of the sphere.
        - radius: The radius of the sphere.
        - color: The color of sphere; defaults to black.
     */
    public convenience init(center: Point, radius: Double, color: Color, finish: Finish, context: NSManagedObjectContext) {
        self.init(context: context)
        self.center = center
        self.radius = radius
        self.color = color
        self.finish = finish
    }
}


// MARK: - Sphere math
extension Sphere {

    /**
     Returns the normal vector from the center to the point.
     - Parameter point: The point for which to compute the normal vector at.
     - Returns: The normal vector from the center to the point.
     */
    public func normal(at point: Point) -> Vector {
        return Vector(from: self.center, to: point).normalized()
    }
}


// MARK: - Sphere string parsing
extension Sphere {

    /**
     Parses a string of format `x y z radius r g b ambient diffuse specular roughness` and creates the corresponding sphere.
     Fails if the string is malformed.
     - Parameter string: The string containing the sphere's data.
     */
    public convenience init?(string: String, context: NSManagedObjectContext) {
        let components = string.components(separatedBy: " ")
            .map { Double($0) }
            .flatMap { $0 }
        guard components.count == 11 else { return nil }
        let center = Point(x: components[0], y: components[1], z: components[2])
        let radius = components[3]
        let color = Color(red: components[4], green: components[5], blue: components[6])
        let finish = Finish(ambient: components[7], diffuse: components[8], specular: components[9], roughness: components[10])
        self.init(center: center, radius: radius, color: color, finish: finish, context: context)
    }

    /// The equation form of the sphere.
    public var equation: String {
        let base = "(x - \(self.center.x))² + (y - \(self.center.y))² + (z - \(self.center.z))² = \(self.radius)"
        return base.replacingOccurrences(of: "- -", with: "+ ")
    }
}


extension Sphere {
    public static func == (lhs: Sphere, rhs: Sphere) -> Bool {
        return lhs.center == rhs.center &&
            lhs.radius == rhs.radius &&
            lhs.color == rhs.color &&
            lhs.finish == rhs.finish
    }
}

