//
//  DoubleTests.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/12/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import XCTest
@testable import RayTracer

class DoubleTests: XCTestCase {

    func testAlmostEqual() {
        XCTAssert(1.333 ~== 1.334)
        XCTAssert(1.333 ~== 1.32)
        XCTAssert(1.3 ~== 1.39)
        XCTAssert(!(1.3 ~== 1.41))
        XCTAssert(!(1.3 ~== 1.19))
    }
    
}
