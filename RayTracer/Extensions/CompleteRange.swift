//
//  CompleteRange.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/14/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import Foundation


protocol CompleteRange {
    associatedtype Bound
    var lowerBound: Bound { get }
    var upperBound: Bound { get }
}

extension CountableRange: CompleteRange { }
extension CountableClosedRange: CompleteRange { }

extension CompleteRange where Self: Collection, Bound == Int {

    /// Returns a random integer in the range 0..<n
    private func random(_ n: Int) -> Int {
        return Int(arc4random_uniform(UInt32(n)))
    }

    /// Returns a random integer in the range.
    func random() -> Int {
        return random(numericCast(self.count)) + self.lowerBound
    }

    /// Returns a random double in the range, above the minimum value, to the number of decimal places.
    /// Upper bound value does not fall into the random range regardless of range type.
    func random(decimalPlaces: Int, above minimum: Double? = nil) -> Double {
        let min = minimum ?? Double(self.lowerBound)
        assert(min < Double(self.upperBound))
        
        let divisor = pow(10, Double(decimalPlaces))
        let countValue: Int = numericCast(self.count)
        let count = (self.upperBound - self.lowerBound == countValue) ? countValue : (countValue - 1)
        let scaledCount = numericCast(count) * Int(divisor)

        var value: Double
        repeat {
            value = (Double(random(scaledCount)) / divisor) + Double(self.lowerBound)
        } while value < min

        return value
    }
}
