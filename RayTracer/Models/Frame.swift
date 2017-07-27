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

    /// Represents the coordinate view for the frame.
    struct View {

        /// The lower x-bound of the view.
        var minX: Double

        /// The upper x-bound of the view.
        var maxX: Double

        /// The lower y-bound of the view.
        var minY: Double

        /// The upper y-bound of the view.
        var maxY: Double

        /// The z-plane on which the view is seen.
        var zPlane: Double
    }

    /// The width of the frame.
    var width: Int {
        didSet {
            freeHeight = height
        }
    }

    /// The height of the frame.
    var height: Int {
        get {
            return aspectRatio == .freeform ? freeHeight : Int(Double(width) / aspectRatio.ratio)
        }
        set {
            if aspectRatio != .freeform {
                width = Int(Double(newValue) * aspectRatio.ratio)
            }
            freeHeight = newValue
        }
    }

    /// The height of the frame to be used with the freeform aspect ratio.
    private var freeHeight: Int

    /// The enforced aspect ratio of the frame.
    var aspectRatio: AspectRatio {
        didSet {
            freeHeight = height
        }
    }

    /// Describes options for the width to height ratio of the frame.
    enum AspectRatio: Int {
        case freeform
        case fourThree
        case sixteenNine

        var ratio: Double {
            switch self {
            case .freeform:
                return 0
            case .fourThree:
                return 4.0 / 3.0
            case .sixteenNine:
                return 16.0 / 9.0
            }
        }
    }

    fileprivate var actualAspectRatio: Double {
        return (Double(width) / Double(height))
    }

    init(view: View, width: Int, height: Int, aspectRatio: AspectRatio) {
        self.view = view
        self.width = width
        self.freeHeight = height
        self.aspectRatio = aspectRatio
    }
}


extension Frame: CustomStringConvertible, CustomDebugStringConvertible {
    var description: String {
        return "Frame(minX: \(self.view.minX), maxX: \(self.view.maxX), minY: \(self.view.minY), maxY: \(self.view.maxY), zPlane: \(self.view.zPlane), width: \(self.width), height: \(self.height), aspectRatio: \(self.aspectRatio.ratio), actualAspectRatio: \(self.actualAspectRatio))"
    }

    var debugDescription: String {
        return self.description
    }
}
