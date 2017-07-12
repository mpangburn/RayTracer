//
//  Frame.swift
//  RayTracer
//
//  Created by Michael Pangburn on 6/26/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import Foundation


/// Represents the view frame for a ray tracing scene.
struct Frame {

    /// The minimum x-value of the frame.
    var minX: Double

    /// The maximum x-value of the frame.
    var maxX: Double

    /// The minimum y-value of the frame.
    var minY: Double

    /// The maximum y-value of the frame.
    var maxY: Double

    /// The width of the frame.
    var width: Int

    /// The height of the frame.
    var height: Int
}


extension Frame: CustomStringConvertible, CustomDebugStringConvertible {
    var description: String {
        return "Frame(minX: \(self.minX), maxX: \(self.maxX), minY: \(self.minY), maxY: \(self.maxY), width: \(self.width), height: \(self.height))"
    }

    var debugDescription: String {
        return self.description
    }
}
