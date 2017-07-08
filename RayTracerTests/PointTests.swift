//
//  PointTests.swift
//  RayTracer
//
//  Created by Michael Pangburn on 6/25/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import XCTest
@testable import RayTracer

class PointTests: XCTestCase {

    let point1 = Point(x: 1, y: 2, z: 3)
    let point2 = Point(x: 0, y: 2, z: 4)

    func testInit() {
        XCTAssert(point1.x == 1)
        XCTAssert(point1.y == 2)
        XCTAssert(point1.z == 3)
    }

    func testEquals() {
        XCTAssert(point1 == Point(x: 1, y: 2, z: 3))
        XCTAssert(point1 != point2)
    }

    func testMath() {
        XCTAssert(point1.translate(by: Vector(x: 3, y: 4, z: 5)) == Point(x: 4, y: 6, z: 8))
        XCTAssert(point1.translate(by: Vector(from: point1, to: point2)) == point2)
    }
}
