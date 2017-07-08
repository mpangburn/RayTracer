//
//  Double.swift
//  RayTracer
//
//  Created by Michael Pangburn on 6/26/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import Foundation


extension Double {

    /**
     Converts the value to an 8-bit unsigned integer, where:
        - values greater than 1 return 255,
        - values between 0 and 255 (inclusive) are multiplied by 255, and
        - values less than 0 return 0.
     */
    var pixelDataValue: UInt8 {
        if self < 0 {
            return UInt8.min
        } else if self > 1 {
            return UInt8.max
        } else {
            return UInt8(self * 255)
        }
    }
}
