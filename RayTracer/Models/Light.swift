//
//  Light.swift
//  RayTracer
//
//  Created by Michael Pangburn on 6/26/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import Foundation


/// Represents a light emitted in 3D space.
public struct Light {

    /// The position of the light.
    public var position: Point

    /// The color of the light.
    public var color: Color
}


extension Light: Equatable { }

public func == (lhs: Light, rhs: Light) -> Bool {
    return lhs.position == rhs.position && lhs.color == rhs.color
}


extension Light: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return "Light(position: \(self.position), color: \(self.color))"
    }

    public var debugDescription: String {
        return self.description
    }
}
