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

    var width: Int {
        willSet {
            if !matchesAspectRatio {
                updateHeightForAspectRatio()
            }
        }
    }

    var height: Int {
        didSet {
            if !matchesAspectRatio {
                updateWidthForAspectRatio()
            }
        }
    }

    /// The aspect ratio of the frame.
    var aspectRatio: AspectRatio {
        didSet {
            if !matchesAspectRatio {
                updateHeightForAspectRatio()
            }
        }
    }

    private mutating func updateHeightForAspectRatio() {
        height = Int(Double(width) / aspectRatio.ratio)
    }

    private mutating func updateWidthForAspectRatio() {
        width = Int(Double(height) * aspectRatio.ratio)
    }

    /// Describes the width to height ratio of the frame.
    enum AspectRatio: Int {
        case freeform
        case fourThree
        case sixteenNine

        var ratio: Double {
            switch self {
            case .freeform:
                return 0
            case .fourThree:
                return 1.333
            case .sixteenNine:
                return 1.777
            }
        }
    }

    var currentAspectRatio: Double {
        return (Double(width) / Double(height))
    }

    private var matchesAspectRatio: Bool {
//        let epsilon = width > 300 ? 0.005 : 0.1 // how can this be scaled better?
        let epsilon: Double
        switch aspectRatio {
        case .freeform:
            epsilon = 0
        case .fourThree:
            switch width {
            case 0...100:
                epsilon = 0.1
            case 101...200:
                epsilon = 0.05
            case 201...300:
                epsilon = 0.01
            default:
                epsilon = 0.005
            }
        case .sixteenNine:
            switch width {
            case 0...100:
                epsilon = 0.1
            case 101...300:
                epsilon = 0.05
            case 300...700:
                epsilon = 0.01
            default:
                epsilon = 0.005
            }
        }
        return aspectRatio == .freeform || currentAspectRatio.epsilonEquals(aspectRatio.ratio, epsilon: epsilon)
    }
}


extension Frame: CustomStringConvertible, CustomDebugStringConvertible {
    var description: String {
        return "Frame(minX: \(self.view.minX), maxX: \(self.view.maxX), minY: \(self.view.minY), maxY: \(self.view.maxY), zPlane: \(self.view.zPlane), width: \(self.width), height: \(self.height), aspectRatio: \(self.aspectRatio.ratio), currentAspectRatio: \(self.currentAspectRatio))"
    }

    var debugDescription: String {
        return self.description
    }
}
