//
//  VectorTests.swift
//  RayTracer
//
//  Created by Michael Pangburn on 6/25/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import XCTest
@testable import RayTracer

class VectorTests: XCTestCase {

    let vector1 = Vector(x: 1, y: 2, z: 3)
    let vector2 = Vector(x: 3, y: 4, z: 5)
    let vector3 = Vector(x: 0, y: 3, z: 4)

    func testEquals() {
        XCTAssert(vector2 == Vector(x: 3, y: 4, z: 5))
        XCTAssert(vector1 != vector2)
    }

    func testInit() {
        XCTAssert(vector1.x == 1 && vector1.y == 2 && vector1.z == 3)
        XCTAssert(Vector(from: Point(x: 1, y: 2, z: 3), to: Point(x: 5, y: 4, z: 3)) == Vector(x: 4, y: 2, z: 0))
    }

    func testProperties() {
        XCTAssert(vector1.length == sqrt(14))
        XCTAssert(vector3.magnitude == 5)
    }

    func testMath() {
        let normalized = vector3.normalized()
        XCTAssertEqualWithAccuracy(normalized.x, 0, accuracy: 0.00001)
        XCTAssertEqualWithAccuracy(normalized.y, 0.6, accuracy: 0.00001)
        XCTAssertEqualWithAccuracy(normalized.z, 0.8, accuracy: 0.00001)

        XCTAssert(vector1.scaled(by: 3) == Vector(x: 3, y: 6, z: 9))
        XCTAssert(vector1.dot(with: vector2) == 26)
        XCTAssert(vector2.dot(with: vector1) == 26)
        XCTAssert(vector1.cross(with: vector2) == Vector(x: -2, y: 4, z: -2))
        XCTAssert(vector2.cross(with: vector1) == Vector(x: 2, y: -4, z: 2))
    }

    func testMutation() {
        var vector3Copy = vector3
        vector3Copy.scale(by: 2)
        XCTAssert(vector3Copy == Vector(x: 0, y: 6, z: 8))

        vector3Copy.normalize()
        XCTAssertEqualWithAccuracy(vector3Copy.x, 0, accuracy: 0.00001)
        XCTAssertEqualWithAccuracy(vector3Copy.y, 0.6, accuracy: 0.00001)
        XCTAssertEqualWithAccuracy(vector3Copy.z, 0.8, accuracy: 0.00001)
    }

    func testOperators() {
        XCTAssert(vector1 + vector2 == Vector(x: 4, y: 6, z: 8))
        XCTAssert(vector1 - vector2 == Vector(x: -2, y: -2, z: -2))
        XCTAssert(-vector1 == Vector(x: -1, y: -2, z: -3))
        XCTAssert(vector1 * 2 == Vector(x: 2, y: 4, z: 6))
        XCTAssert(3 * vector2 == Vector(x: 9, y: 12, z: 15))
        XCTAssert(vector2 / 2 == Vector(x: 1.5, y: 2, z: 2.5))
    }

    func testCustomOperators() {
        XCTAssert(vector1 × vector2 == Vector(x: -2, y: 4, z: -2))
        XCTAssert(vector2 × vector1 == Vector(x: 2, y: -4, z: 2))
        XCTAssert(vector1 • vector2 == 26)
        XCTAssert(vector2 • vector1 == 26)
    }
}
