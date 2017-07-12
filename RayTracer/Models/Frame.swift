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

    /// The view for the frame.
    var view: View

    /// The size of the frame.
    var size: Size

    /// Represents the view for the frame.
    struct View {
        /// The lower x-bound of the view.
        var minX: Double

        /// The upper x-bound of the view.
        var maxX: Double

        /// The lower y-bound of the view.
        var minY: Double

        /// The upper y-bound of the view.
        var maxY: Double

        /// The z-plane in which the view is drawn.
        var zPlane: Double
    }

    /// Represents the size of the frame.
    struct Size {
        /// The width of the frame.
        var width: Int

        /// The height of the frame.
        var height: Int
    }
}


extension Frame: CustomStringConvertible, CustomDebugStringConvertible {
    var description: String {
        return "Frame(minX: \(self.view.minX), maxX: \(self.view.maxX), minY: \(self.view.minY), maxY: \(self.view.maxY), zPlane: \(self.view.zPlane), width: \(self.size.width), height: \(self.size.height))"
    }

    var debugDescription: String {
        return self.description
    }
}
