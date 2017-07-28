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

    /// The lower x-bound of the view.
    var minX: Double {
        didSet {
            freeMaxX = maxX
            freeMinY = minY
            freeMaxY = maxY
        }
    }

    /// The upper x-bound of the view.
    var maxX: Double {
        get {
            return aspectRatio == .freeform ? freeMaxX : -minX
        }
        set {
            if aspectRatio != .freeform {
                minX = -newValue
            }
            freeMaxX = newValue
        }
    }

    /// The max x value to be used with the freeform aspect ratio.
    private var freeMaxX: Double

    /// The lower y-bound of the view.
    var minY: Double {
        get {
            return aspectRatio == .freeform ? freeMinY : minX / aspectRatio.ratio
        }
        set {
            if aspectRatio != .freeform {
                minX = newValue * aspectRatio.ratio
            }
            freeMinY = newValue
        }
    }

    /// The min y value to be used with the freeform aspect ratio.
    private var freeMinY: Double

    /// The upper y-bound of the view.
    var maxY: Double {
        get {
            return aspectRatio == .freeform ? freeMaxY : -minY
        }
        set {
            if aspectRatio != .freeform {
                minX = -newValue * aspectRatio.ratio
            }
            freeMaxY = newValue
        }
    }

    /// The max y value to be used with the freeform aspect ratio.
    private var freeMaxY: Double

    /// The z-plane on which the view is seen.
    var zPlane: Double

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

    /// The enforced aspect ratio of the frame.
    var aspectRatio: AspectRatio {
        didSet {
            freeMaxX = maxX
            freeMinY = minY
            freeMaxY = maxY
            freeHeight = height
        }
    }

    init(minX: Double, maxX: Double, minY: Double, maxY: Double, zPlane: Double, width: Int, height: Int, aspectRatio: AspectRatio) {
        assert(minX < maxX)
        assert(minY < maxY)
        
        self.minX = minX
        self.freeMaxX = maxX
        self.freeMinY = minY
        self.freeMaxY = maxY
        self.zPlane = zPlane
        self.width = width
        self.freeHeight = height
        self.aspectRatio = aspectRatio
    }
}


extension Frame: CustomStringConvertible, CustomDebugStringConvertible {
    var description: String {
        return "Frame(minX: \(self.minX), maxX: \(self.maxX), minY: \(self.minY), maxY: \(self.maxY), zPlane: \(self.zPlane), width: \(self.width), height: \(self.height), aspectRatio: \(self.aspectRatio.ratio))"
    }

    var debugDescription: String {
        return self.description
    }
}
