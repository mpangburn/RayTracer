//
//  Frame.swift
//  RayTracer
//
//  Created by Michael Pangburn on 6/26/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import Foundation


/// Represents the view frame for a ray tracing scene.
public struct Frame {

    /// The minimum x-value of the frame.
    public var minX: Double

    /// The maximum x-value of the frame.
    public var maxX: Double

    /// The minimum y-value of the frame.
    public var minY: Double

    /// The maximum y-value of the frame.
    public var maxY: Double

    /// The width of the frame.
    public var width: Int

    /// The height of the frame.
    public var height: Int
}


extension Frame: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return "Frame(minX: \(self.minX), maxX: \(self.maxX), minY: \(self.minY), maxY: \(self.maxY), width: \(self.width), height: \(self.height))"
    }

    public var debugDescription: String {
        return self.description
    }
}
