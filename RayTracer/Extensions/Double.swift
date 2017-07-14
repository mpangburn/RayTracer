//
//  Double.swift
//  RayTracer
//
//  Created by Michael Pangburn on 6/26/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import Foundation


// MARK: - Double utilities for image processing
extension Double {

    /// 8-bit integer equivalent of a Double value in the range [0,1].
    var pixelDataValue: UInt8 {
        switch self {
        case let value where value < 0:
            return UInt8.min
        case let value where value > 1:
            return UInt8.max
        default:
            return UInt8(self * 255)
        }
    }
}


// MARK: - Double formatting utilties
extension Double {

    /// Rounds the value to the specified number of decimal places.
    func roundTo(places: Int) -> Double {
        let divisor = pow(10, Double(places))
        return (self * divisor).rounded() / divisor
    }

    /// Displays the whole number percentage of the value.
    var integerPercentage: String {
        switch self {
        case let value where value <= 0:
            return "0%"
        case let value where value >= 1:
            return "100%"
        default:
            return "\(Int(self.roundTo(places: 2) * 100))%"
        }
    }

    /// Displays the value rounded to two decimal places.
    var twoDigitDecimalString: String {
        return String(format: "%.2f", self.roundTo(places: 2))
    }

    /// Displays the decimal point and the digits that follow only if they are nonzero.
    var cleanValueString: String {
        if self.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", self)
        }
        else {
            return String(self)
        }
    }
}
