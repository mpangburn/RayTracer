//
//  Light.swift
//  RayTracer
//
//  Created by Michael Pangburn on 6/26/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import Foundation


/// Represents a light emitted in 3D space.
struct Light {

    /// The position of the light.
    var position: Point

    /// The color of the light.
    var color: Color

    /// Values representing possible light intensities.
    enum Intensity: Double {
        case low = 0.5
        case medium = 1.0
        case high = 1.5
    }

    /// The intensity of the light.
    var intensity: Intensity

    /// The effective color of the light, factoring in intensity.
    var effectiveColor: Color {
        return color.withComponentsScaled(by: intensity.rawValue)
    }
}


extension Light: Equatable { }

func == (lhs: Light, rhs: Light) -> Bool {
    return lhs.position == rhs.position && lhs.color == rhs.color
}


extension Light: CustomStringConvertible, CustomDebugStringConvertible {
    var description: String {
        return "Light(position: \(self.position), color: \(self.color))"
    }

    var debugDescription: String {
        return self.description
    }
}
