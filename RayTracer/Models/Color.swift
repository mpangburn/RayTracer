//
//  Color.swift
//  RayTracer
//
//  Created by Michael Pangburn on 6/26/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import Foundation


/// Represents a color using the RGBA color space.
/// Each of the color's components falls in the interval [0,1].
public class Color: NSObject {

    /// The color's red component.
    public var red: Double

    /// The color's green component.
    public var green: Double

    /// The color's blue component.
    public var blue: Double

    /// The color's alpha component.
    public var alpha: Double

    /**
     Creates the color with the RGBA components.
     - Parameters:
        - red: The color's red component.
        - green: The color's green component.
        - blue: The color's blue component.
        - alpha: The color's alpha component; defaults to 1.0.
     */
    public init(red: Double, green: Double, blue: Double, alpha: Double = 1.0) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
}


// MARK: - Pixel data
extension Color {

    /// Represents the color's components in 8-bit unsigned integer form.
    public typealias PixelData = (red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8)

    public var pixelData: PixelData {
        return (red: self.red.pixelDataValue, green: self.green.pixelDataValue, blue: self.blue.pixelDataValue, alpha: self.alpha.pixelDataValue)
    }

}


// MARK: - Color constants
extension Color {

    /// The color black.
    public static var black: Color {
        return Color(red: 0, green: 0, blue: 0, alpha: 0)
    }

    /// The color white.
    public static var white: Color {
        return Color(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
}


// MARK: - Equatability
extension Color {
    public static func == (lhs: Color, rhs: Color) -> Bool {
        return lhs.red == rhs.red &&
            lhs.green == rhs.green &&
            lhs.blue == rhs.blue &&
            lhs.alpha == rhs.alpha
    }
}


// MARK: - Description
extension Color {
    override public var description: String {
        return "Color(red: \(self.red), green: \(self.green), blue: \(self.blue), alpha: \(self.alpha))"
    }
}

