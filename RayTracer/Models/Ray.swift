//
//  Ray.swift
//  RayTracer
//
//  Created by Michael Pangburn on 6/26/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import Foundation


/// Represents a ray in 3D space.
struct Ray {

    /// The initial point of the ray.
    var initial: Point

    /// The direction of the ray.
    var direction: Vector
}


// MARK: - Ray math
extension Ray {

    /**
     Returns the point on the ray computed by scaling its direction by the value.
     - Parameter t: The parameter value used to compute the point.
     - Returns: The point on the ray computed by scaling its direction by the value.
     */
    func pointForVectorScaled(by t: Double) -> Point {
        return self.initial.translate(by: t * self.direction)
    }

    /**
     Returns the point where the ray intersects the sphere, if it exists.
     - Parameter sphere: The sphere to check for intersection with.
     - Returns: The point where the ray intersects the sphere, if it exists.
     */
    func intersection(with sphere: Sphere) -> Point? {
        let vectorFromCenterToInitial = Vector(from: sphere.center, to: self.initial)

        // Solves the quadratic for the value(s) of t for which
        // ray.pointForVectorScaled(by: t), t >= 0
        // intersects the sphere.
        let a = self.direction • self.direction
        let b = 2 * vectorFromCenterToInitial • self.direction
        let c = (vectorFromCenterToInitial • vectorFromCenterToInitial) - (sphere.radius * sphere.radius)

        guard let (t1, t2) = Utilities.rootsOfQuadratic(a: a, b: b, c: c), t1 > 0 || t2 > 0 else { return nil }

        switch (t1, t2) {
        case (let t1, let t2) where t1 == t2:
            return self.pointForVectorScaled(by: t1)
        case (let t1, let t2) where t1 < 0 || t2 < 0:
            return self.pointForVectorScaled(by: max(t1, t2))
        case (let t1, let t2) where t1 > 0 && t2 > 0:
            return self.initial.closest(of: self.pointForVectorScaled(by: t1), self.pointForVectorScaled(by: t2))
        default:
            return nil
        }
    }

    /// A ray's intersection with a sphere.
    typealias Intersection = (sphere: Sphere, point: Point)

    /**
     Returns the intersections of the ray with the spheres.
     - Parameter spheres: The spheres to check for intersections with.
     - Returns: A list of tuples, each containing a sphere and the point where the ray intersects it.
     */
    func intersections(with spheres: [Sphere]) -> [Intersection] {
        var intersections: [(sphere: Sphere, point: Point)] = []
        for sphere in spheres {
            if let intersection = self.intersection(with: sphere) {
                intersections.append((sphere: sphere, point: intersection))
            }
        }
        return intersections
    }

    /**
     Returns the closest of the spheres with which the ray intersects.
     - Parameter spheres: The spheres to compute distance from.
     - Returns: The closest of the spheres with which the ray intersects.
     */
    func closestIntersection(with spheres: [Sphere]) -> Intersection? {
        let intersections = self.intersections(with: spheres)
        guard intersections.count > 0 else { return nil }

        var closestIntersection = intersections[0]
        var smallestDistance = self.initial.distance(from: intersections[0].point)
        for i in 1..<intersections.count {
            let distance = self.initial.distance(from: intersections[i].point)
            if distance < smallestDistance {
                closestIntersection = intersections[i]
                smallestDistance = distance
            }
        }

        return closestIntersection
    }
}


extension Ray: Equatable { }

func == (lhs: Ray, rhs: Ray) -> Bool {
    return lhs.initial == rhs.initial && lhs.direction == rhs.direction
}

func == (lhs: Ray.Intersection, rhs: Ray.Intersection) -> Bool {
    return lhs.sphere == rhs.sphere && lhs.point == rhs.point
}


extension Ray: CustomStringConvertible, CustomDebugStringConvertible {
    var description: String {
        return "Ray(initial: \(self.initial), direction: \(self.direction))"
    }

    var debugDescription: String {
        return self.description
    }
}
