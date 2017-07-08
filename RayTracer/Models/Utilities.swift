//
//  Utilities.swift
//  RayTracer
//
//  Created by Michael Pangburn on 6/26/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import Foundation


/// Contains utility functions for ray tracing.
struct Utilities {

    /**
     Returns the value(s) of `x` that solve the quadratic equation of form

        `ax² + bx + c = 0`

     if its solutions are real.
     - Parameters:
        - a: The coefficient of the quadratic term.
        - b: The coefficient of the linear x term.
        - c: The constant term.
     - Returns: The tuple of x values that solve the quadratic equation if its solutions are real.
     */
    static func rootsOfQuadratic(a: Double, b: Double, c: Double) -> (Double, Double)? {
        let discriminant = (b * b) - (4 * a * c)
        guard discriminant >= 0 else { return nil }
        let root1 = (-b - sqrt(discriminant)) / (2 * a)
        let root2 = (-b + sqrt(discriminant)) / (2 * a)
        return (root1, root2)
    }
}
