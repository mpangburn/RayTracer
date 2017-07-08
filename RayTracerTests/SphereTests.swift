//
//  SphereTests.swift
//  RayTracer
//
//  Created by Michael Pangburn on 6/26/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import XCTest
@testable import RayTracer

class SphereTests: XCTestCase {

    var sphere1: Sphere!
    var sphere2: Sphere!
    let context = setUpInMemoryManagedObjectContext()

    override func setUp() {
        sphere1 = Sphere(center: Point.zero, radius: 1, context: context)
        sphere2 = Sphere(center: Point(x: 1, y: 2, z: 3), radius: 5, context: context)
    }

    func testEquals() {
        XCTAssert(sphere1 == Sphere(center: Point.zero, radius: 1, context: context))
        XCTAssert(sphere1 != sphere2)
    }

    func testMath() {
        XCTAssert(sphere1.normal(at: Point(x: 1, y: 0, z: 0)) == Vector(x: 1, y: 0, z: 0))
        XCTAssert(sphere2.normal(at: Point(x: 6, y: 2, z: 3)) == Vector(x: 5, y: 0, z: 0).normalized())
    }

}
