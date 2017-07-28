//
//  RayTracerTests.swift
//  RayTracerTests
//
//  Created by Michael Pangburn on 7/8/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import XCTest
@testable import RayTracer

class RayTracerTests: XCTestCase {

    let tracer = RayTracer.shared
    let context = setUpInMemoryManagedObjectContext()
    
    override func setUp() {
        super.setUp()
        let sphere1 = Sphere(string: "1.0 1.0 0.0 2.0 1.0 0.0 1.0 0.2 0.4 0.5 0.05", context: context)!
        let sphere2 = Sphere(string: "8.0 -10.0 100.0 90.0 0.2 0.2 0.6 0.4 0.8 0.0 0.05", context: context)!
        tracer.spheres = [sphere1, sphere2]

        let eyePoint = Point(x: 0, y: 0, z: -14)
        let light = Light(position: Point(x: -100, y: 100, z: -100), color: Color.white, intensity: .high)
        let ambience = Color.white
        let backgroundColor: Color = Color.white
        let sceneFrame = Frame(view: Frame.View(minX: -10, maxX: 10, minY: -7.5, maxY: 7.5, zPlane: 0), width: 512, height: 384, aspectRatio: .fourThree)
        tracer.settings = RayTracerSettings(eyePoint: eyePoint, light: light, ambience: ambience, backgroundColor: backgroundColor, sceneFrame: sceneFrame)
    }

    func testCast() {
        let settings = tracer.settings
        let x = settings.sceneFrame.view.minX
        let y = settings.sceneFrame.view.maxY
        let direction = Vector(from: settings.eyePoint, to: Point(x: x, y: y, z: settings.sceneFrame.view.zPlane))
        let ray = Ray(initial: settings.eyePoint, direction: direction)
        XCTAssert(tracer.cast(ray: ray) == (red: 80, green: 80, blue: 240, alpha: 255))
    }
}
