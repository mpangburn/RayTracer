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
final class Color: NSObject, NSCoding {

    /// The color's red component.
    var red: Double

    /// The color's green component.
    var green: Double

    /// The color's blue component.
    var blue: Double

    /// The color's alpha component.
    var alpha: Double

    /**
     Creates the color with the RGBA components.
     - Parameters:
        - red: The color's red component.
        - green: The color's green component.
        - blue: The color's blue component.
        - alpha: The color's alpha component, which defaults to 1.0.
     */
    init(red: Double, green: Double, blue: Double, alpha: Double = 1.0) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    private enum CodingKey: String {
        case red, green, blue, alpha
    }

    required convenience init?(coder aDecoder: NSCoder) {
        let red = aDecoder.decodeDouble(forKey: CodingKey.red.rawValue)
        let green = aDecoder.decodeDouble(forKey: CodingKey.green.rawValue)
        let blue = aDecoder.decodeDouble(forKey: CodingKey.blue.rawValue)
        let alpha = aDecoder.decodeDouble(forKey: CodingKey.alpha.rawValue)
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.red, forKey: CodingKey.red.rawValue)
        aCoder.encode(self.green, forKey: CodingKey.green.rawValue)
        aCoder.encode(self.blue, forKey: CodingKey.blue.rawValue)
        aCoder.encode(self.alpha, forKey: CodingKey.alpha.rawValue)
    }

    /**
     Returns the color with each of its components multiplied by the scalar.
     - Parameter scalar: The value to multiply each component by.
     - Returns: The color with each of his components multiplied by the scalar.
     */
    func withComponentsScaled(by scalar: Double) -> Color {
        return Color(red: self.red * scalar, green: self.green * scalar, blue: self.blue * scalar)
    }
}


// MARK: - Pixel data
extension Color {

    /// Represents the color's components in 8-bit unsigned integer form.
    typealias PixelData = (red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8)

    /// The pixel data for the color, using unsigned 8-bit integer values.
    var pixelData: PixelData {
        return (red: self.red.pixelDataValue, green: self.green.pixelDataValue, blue: self.blue.pixelDataValue, alpha: self.alpha.pixelDataValue)
    }
}


// MARK: - Color constants and utilities
extension Color {

    /// The color black.
    static var black: Color {
        return Color(red: 0.0, green: 0.0, blue: 0.0)
    }

    /// The color white.
    static var white: Color {
        return Color(red: 1.0, green: 1.0, blue: 1.0)
    }

    /// Returns a random color.
    static func random() -> Color {
        let colorRange = 0...1
        let red = colorRange.random(decimalPlaces: 2)
        let green = colorRange.random(decimalPlaces: 2)
        let blue = colorRange.random(decimalPlaces: 2)
        return Color(red: red, green: green, blue: blue)
    }
}


extension Color {
    static func == (lhs: Color, rhs: Color) -> Bool {
        return lhs.red == rhs.red &&
            lhs.green == rhs.green &&
            lhs.blue == rhs.blue &&
            lhs.alpha == rhs.alpha
    }
}


extension Color {
    override var description: String {
        return "Color(red: \(self.red), green: \(self.green), blue: \(self.blue), alpha: \(self.alpha))"
    }
}

