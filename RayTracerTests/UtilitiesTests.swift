//
//  UtilitiesTests.swift
//  RayTracer
//
//  Created by Michael Pangburn on 6/26/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import XCTest
@testable import RayTracer

class UtilitiesTests: XCTestCase {

    func testQuadraticSolver() {
        XCTAssertNil(Utilities.rootsOfQuadratic(a: 1, b: 0, c: 1))
        XCTAssert(Utilities.rootsOfQuadratic(a: 1, b: 0, c: -16)! == (-4, 4))
        XCTAssert(Utilities.rootsOfQuadratic(a: 1, b: 4, c: 4)! == (-2, -2))
    }
}
