//
//  Vector.swift
//  RayTracer
//
//  Created by Michael Pangburn on 6/25/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import Foundation


/// Represents a vector in 3D space.
struct Vector {

    /// The x-component of the vector.
    var x: Double

    /// The y-component of the vector.
    var y: Double

    /// The z-component of the vector.
    var z: Double

    /**
     Creates a vector from the given components.
     - Parameters:
        - x: The x-component of the vector.
        - y: The y-component of the vector.
        - z: The z-component of the vector.
     */
    init(x: Double, y: Double, z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }

    /**
     Creates a vector from the initial point to the terminal point.
     - Parameters:
        - initial: The point from which the vector begins.
        - terminal: The point at which the vector ends.
     */
    init(from initial: Point, to terminal: Point) {
        self.init(x: terminal.x - initial.x, y: terminal.y - initial.y, z: terminal.z - initial.z)
    }
}


// MARK: - Vector properties
extension Vector {

    /// The length of the vector, equivalent to its magnitude.
    var length: Double {
        return sqrt((x * x) + (y * y) + (z * z))
    }

    /// The magnitude of the vector, equivalent to its length.
    var magnitude: Double {
        return self.length
    }
}


// MARK: - Vector math
extension Vector {


    /// Normalizes the vector.
    mutating func normalize() {
        self = self.normalized()
    }

    /**
     Returns the normalized vector.
     - Returns: The vector with the same direction and magnitude 1.
     */
    func normalized() -> Vector {
        return self / self.magnitude
    }

    /**
     Scales the vector by the scalar.
     - Parameter scalar: The scalar to scale by.
     */
    mutating func scale(by scalar: Double) {
        self = self.scaled(by: scalar)
    }

    /**
     Returns the vector scaled by the scalar.
     - Parameter scalar: The scalar to scale by.
     - Returns: The vector scaled by the scalar.
     */
    func scaled(by scalar: Double) -> Vector {
        return Vector(x: self.x * scalar, y: self.y * scalar, z: self.z * scalar)
    }

    /**
     Returns the dot product with the given vector.
     - Parameter other: The vector to dot with.
     - Returns: The dot product of the vectors.
     */
    func dot(with other: Vector) -> Double {
        return (self.x * other.x) + (self.y * other.y) + (self.z * other.z)
    }

    /**
     Returns the cross product with the given vector.
     - Parameter other: The vector to cross with.
     - Returns: The cross product of the vectors.
     */
    func cross(with other: Vector) -> Vector {
        let xComponent = self.y * other.z - self.z * other.y
        let yComponent = -(self.x * other.z - self.z * other.x)
        let zComponent = self.x * other.y - self.y * other.x
        return Vector(x: xComponent, y: yComponent, z: zComponent)
    }
}


// MARK: - Vector operators
extension Vector {

    /// Negates each component of the vector.
    static prefix func - (vector: Vector) -> Vector {
        return Vector(x: -vector.x, y: -vector.y, z: -vector.z)
    }

    /// Adds the components of the two vectors.
    static func + (lhs: Vector, rhs: Vector) -> Vector {
        return Vector(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }

    /// Subtracts the components of the second vector from the first.
    static func - (lhs: Vector, rhs: Vector) -> Vector {
        return lhs + (-rhs)
    }

    /// Multiplies each component of the the vector by the scalar.
    static func * (lhs: Vector, rhs: Double) -> Vector {
        return lhs.scaled(by: rhs)
    }

    /// Multiplies each component of the the vector by the scalar.
    static func * (lhs: Double, rhs: Vector) -> Vector {
        return rhs.scaled(by: lhs)
    }

    /// Divides each component of the vector by the scalar.
    static func / (lhs: Vector, rhs: Double) -> Vector {
        return lhs * (1 / rhs)
    }
}


// MARK: - Custom vector operators
infix operator •: MultiplicationPrecedence
infix operator ×: MultiplicationPrecedence

extension Vector {

    /// Returns the dot product of the two vectors.
    static func • (lhs: Vector, rhs: Vector) -> Double {
        return lhs.dot(with: rhs)
    }

    /// Returns the cross product of the two vectors.
    static func × (lhs: Vector, rhs: Vector) -> Vector {
        return lhs.cross(with: rhs)
    }
}


// MARK: - Vector constants
extension Vector {

    /// The zero vector.
    static var zero: Vector {
        return Vector(x: 0, y: 0, z: 0)
    }
}


extension Vector: Equatable { }

func == (lhs: Vector, rhs: Vector) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
}


extension Vector: CustomStringConvertible, CustomDebugStringConvertible {
    var description: String {
        return "<\(self.x), \(self.y), \(self.z)>"
    }

    var debugDescription: String {
        return "Vector(x: \(self.x), y: \(self.y), z: \(self.z))"
    }
}
