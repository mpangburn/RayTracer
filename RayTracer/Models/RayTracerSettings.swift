//
//  RayTracerSettings.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/11/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import Foundation


struct RayTracerSettings {

    /// The point from which the scene is viewed.
    var eyePoint = Point(x: 0, y: 0, z: -14)

    /// The light for the scene.
    var light = Light(position: Point(x: -100, y: 100, z: -100), color: Color.white, intensity: .high)

    /// The ambient color for the scene.
    var ambience = Color.white

    /// The frame for the scene.
    var sceneFrame = Frame(minX: -10, maxX: 10, minY: -7.5, maxY: 7.5, width: 512, height: 384)
}


extension RayTracerSettings: RawRepresentable {
    typealias RawValue = [String: Any]

    init?(rawValue: RawValue) {
        if let eyePointData = rawValue["eyePoint"] as? Data,
            let eyePoint = NSKeyedUnarchiver.unarchiveObject(with: eyePointData) as? Point {
            self.eyePoint = eyePoint
        }

        if let lightDict = rawValue["light"] as? [String: Data],
            let lightPosition = NSKeyedUnarchiver.unarchiveObject(with: lightDict["position"]!) as? Point,
            let lightColor = NSKeyedUnarchiver.unarchiveObject(with: lightDict["color"]!) as? Color {
            self.light = Light(position: lightPosition, color: lightColor)
        }

        if let ambienceData = rawValue["ambience"] as? Data,
            let ambience = NSKeyedUnarchiver.unarchiveObject(with: ambienceData) as? Color {
            self.ambience = ambience
        }

        if let sceneFrameDict = rawValue["sceneFrame"] as? [String: Any] {
            let sceneFrame = Frame(minX: sceneFrameDict["minX"] as! Double,
                                   maxX: sceneFrameDict["maxX"] as! Double,
                                   minY: sceneFrameDict["minY"] as! Double,
                                   maxY: sceneFrameDict["maxY"] as! Double,
                                   width: sceneFrameDict["width"] as! Int,
                                   height: sceneFrameDict["height"] as! Int)
            self.sceneFrame = sceneFrame
        }
    }

    var rawValue: RawValue {
        var raw: RawValue = [:]

        raw["eyePoint"] = NSKeyedArchiver.archivedData(withRootObject: eyePoint)

        raw["light"] = [
            "position": NSKeyedArchiver.archivedData(withRootObject: light.position),
            "color": NSKeyedArchiver.archivedData(withRootObject: light.color)
        ]

        raw["ambience"] = NSKeyedArchiver.archivedData(withRootObject: ambience)

        raw["sceneFrame"] = [
            "minX": sceneFrame.minX,
            "maxX": sceneFrame.maxX,
            "minY": sceneFrame.minY,
            "maxY": sceneFrame.maxY,
            "width": sceneFrame.width,
            "height": sceneFrame.height
        ]

        return raw

    }

}
