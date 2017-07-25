//
//  RayTests.swift
//  RayTracer
//
//  Created by Michael Pangburn on 6/26/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import XCTest
@testable import RayTracer

class RayTests: XCTestCase {

    let ray1 = Ray(initial: Point.zero, direction: Vector(x: 1, y: 2, z: 3))
    let ray2 = Ray(initial: Point(x: 1, y: 2, z: 3), direction: Vector(x: 3, y: 4, z: 5))
    let context = setUpInMemoryManagedObjectContext()

    func testEquals() {
        XCTAssert(ray1 == Ray(initial: Point.zero, direction: Vector(x: 1, y: 2, z: 3)))
        XCTAssert(ray1 != ray2)
    }

    func testMath() {
        XCTAssert(ray1.pointForVectorScaled(by: 0) == Point.zero)
        XCTAssert(ray2.pointForVectorScaled(by: 1.5) == Point(x: 5.5, y: 8, z: 10.5))
    }

    func testIntersections() {
        let ray3 = Ray(initial: Point.zero, direction: Vector(x: 0, y: 4, z: 0))
        let sphere1 = Sphere(center: Point.zero, radius: 3, context: context)
        let intersection1 = Point(x: 0, y: 3, z: 0)
        XCTAssert(ray3.intersection(with: sphere1)! == intersection1)

        let sphere2 = Sphere(center: Point.zero, radius: 4, context: context)
        let intersection2 = Point(x: 0, y: 4, z: 0)
        XCTAssert(ray3.intersection(with: sphere2)! == intersection2)

        let sphere3 = Sphere(center: Point(x: 10, y: 10, z: 10), radius: 5, context: context)
        XCTAssertNil(ray3.intersection(with: sphere3))

        let expectedIntersections = [
            (sphere: sphere1, point: intersection1),
            (sphere: sphere2, point: intersection2)
        ]
        let ray3Intersections = ray3.intersections(with: [sphere1, sphere2, sphere3])
        XCTAssert(ray3Intersections.count == expectedIntersections.count)
        for i in 0..<ray3Intersections.count {
            XCTAssert(ray3Intersections[i] == expectedIntersections[i])
        }
        XCTAssert(ray3.closestIntersection(with: [sphere1, sphere2, sphere3])! == expectedIntersections[0])

        let ray4 = Ray(initial: Point(x: 0, y: -9, z: 0), direction: Vector(x: 0, y: 4, z: 0))
        let sphere4 = Sphere(center: Point.zero, radius: 5, context: context)
        XCTAssert(ray4.intersection(with: sphere4)! == Point(x: 0, y: -5, z: 0))

        let ray5 = Ray(initial: Point(x: 0, y: -10, z: 0), direction: Vector(x: 0, y: 20, z: 0))
        let sphere5 = Sphere(center: Point.zero, radius: 5, context: context)
        XCTAssert(ray5.intersection(with: sphere5)! == Point(x: 0, y: -5, z: 0))
    }
}
