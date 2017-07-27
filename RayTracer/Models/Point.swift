//
//  Point.swift
//  RayTracer
//
//  Created by Michael Pangburn on 6/25/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import Foundation


/// Represents a point in 3D space.
final class Point: NSObject, NSCoding {

    /// The x-coordinate of the point.
    var x: Double

    /// The y-coordinate of the point.
    var y: Double

    /// The z-coordinate of the point.
    var z: Double

    /**
     Creates a point with the coordintates.
     - Parameters:
        - x: The x-coordinate of the point.
        - y: The y-coordinate of the point.
        - z: The z-coordinate of the point.
     */
    init(x: Double, y: Double, z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }

    // MARK: - NSCoding

    private enum CodingKey: String {
        case x, y, z
    }

    required convenience init?(coder aDecoder: NSCoder) {
        let x = aDecoder.decodeDouble(forKey: CodingKey.x.rawValue)
        let y = aDecoder.decodeDouble(forKey: CodingKey.y.rawValue)
        let z = aDecoder.decodeDouble(forKey: CodingKey.z.rawValue)
        self.init(x: x, y: y, z: z)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.x, forKey: CodingKey.x.rawValue)
        aCoder.encode(self.y, forKey: CodingKey.y.rawValue)
        aCoder.encode(self.z, forKey: CodingKey.z.rawValue)
    }
}


// MARK: - Point math
extension Point {

    /**
     Translates the point by the vector.
     - Parameter vector: The vector to translate by.
     - Returns: The point translated by the vector.
     */
    func translate(by vector: Vector) -> Point {
        return Point(x: self.x + vector.x, y: self.y + vector.y, z: self.z + vector.z)
    }

    /**
     Computes the distance between the two points.
     - Parameter other: The point to compute distance from.
     - Returns: The distance between the two points.
     */
    func distance(from other: Point) -> Double {
        return Vector(from: other, to: self).length
    }

    /**
     Returns the closest of the points to the point.
     - Parameter points: The points of which to determine the closest.
     - Returns: The closest of the points to the point.
     */
    func closest(of points: [Point]) -> Point {
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
    func closest(of points: Point...) -> Point {
        return closest(of: points)
    }
}


// MARK: - Point constants
extension Point {

    /// The point with the coordinates (0,0,0); the origin.
    static var zero: Point {
        return Point(x: 0, y: 0, z: 0)
    }
}


extension Point {
    static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
}


extension Point {
    override var description: String {
        return "(\(self.x), \(self.y), \(self.z))"
    }

    override var debugDescription: String {
        return "Point(x: \(self.x), y: \(self.y), z: \(self.z))"
    }
}
