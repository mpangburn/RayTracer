//
//  Point.swift
//  RayTracer
//
//  Created by Michael Pangburn on 6/25/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import Foundation


/// Represents a point in 3D space.
public class Point: NSObject {

    /// The x-coordinate of the point.
    public var x: Double

    /// The y-coordinate of the point.
    public var y: Double

    /// The z-coordinate of the point.
    public var z: Double

    /**
     Creates a point with the coordintates.
     - Parameters:
        - x: The x-coordinate of the point.
        - y: The y-coordinate of the point.
        - z: The z-coordinate of the point.
     */
    public init(x: Double, y: Double, z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }
}


// MARK: - Point math
extension Point {

    /**
     Translates the point by the vector.
     - Parameter vector: The vector to translate by.
     - Returns: The point translated by the vector.
     */
    public func translate(by vector: Vector) -> Point {
        return Point(x: self.x + vector.x, y: self.y + vector.y, z: self.z + vector.z)
    }

    /**
     Computes the distance between the two points.
     - Parameter other: The point to compute distance from.
     - Returns: The distance between the two points.
     */
    public func distance(from other: Point) -> Double {
        return Vector(from: other, to: self).length
    }

    /**
     Returns the closest of the points to the point.
     - Parameter points: The points of which to determine the closest.
     - Returns: The closest of the points to the point.
     */
    public func closest(of points: [Point]) -> Point {
        let distances = points.map { self.distance(from: $0) }
        var smallestDistance = distances[0]
        var closestPointIndex = 0
        for i in 1..<distances.count {
            if distances[i] < smallestDistance {
                smallestDistance = distances[i]
                closestPointIndex = i
            }
        }
        return points[closestPointIndex]
    }

    /**
     Returns the closest of the points to the point.
     - Parameter points: The points of which to determine the closest.
     - Returns: The closest of the points to the point.
     */
    public func closest(of points: Point...) -> Point {
        return closest(of: points)
    }
}


// MARK: - Point constants
extension Point {

    /// The point with the coordinates (0,0,0); the origin.
    public static var zero: Point {
        return Point(x: 0, y: 0, z: 0)
    }
}


// MARK: - Equatability
extension Point {
    public static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
}


// MARK: - Description
extension Point {
    override public var description: String {
        return "Point(x: \(self.x), y: \(self.y), z: \(self.z))"
    }
}
