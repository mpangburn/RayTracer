//
//  RayTracerSettings.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/11/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import Foundation


/// Stores scene settings for ray tracing.
struct RayTracerSettings {

    /// The point from which the scene is viewed.
    var eyePoint = Point(x: 0, y: 0, z: -14)

    /// The light for the scene.
    var light = Light(position: Point(x: -100, y: 100, z: -100), color: Color.white, intensity: .high)

    /// The ambient color for the scene.
    var ambience = Color.white

    /// The background color for the scene.
    var backgroundColor: Color = Color.white

    /// The frame for the scene.
    var sceneFrame = Frame(minX: -10, maxX: 10, minY: -7.5, maxY: 7.5, zPlane: 0, width: 512, height: 384, aspectRatio: .fourThree)
}


extension RayTracerSettings: RawRepresentable {
    typealias RawValue = [String: Any]

    init?(rawValue: RawValue) {
        if let eyePointData = rawValue["eyePoint"] as? Data,
            let eyePoint = NSKeyedUnarchiver.unarchiveObject(with: eyePointData) as? Point {

            self.eyePoint = eyePoint
        }

        if let lightDict = rawValue["light"] as? [String: Any],
            let lightPositionData = lightDict["position"] as? Data,
            let lightPosition = NSKeyedUnarchiver.unarchiveObject(with: lightPositionData) as? Point,
            let lightColorData = lightDict["color"] as? Data,
            let lightColor = NSKeyedUnarchiver.unarchiveObject(with: lightColorData) as? Color,
            let intensityRawValue = lightDict["intensity"] as? Int,
            let intensity = Light.Intensity(rawValue: intensityRawValue) {

            self.light = Light(position: lightPosition, color: lightColor, intensity: intensity)
        }

        if let ambienceData = rawValue["ambience"] as? Data,
            let ambience = NSKeyedUnarchiver.unarchiveObject(with: ambienceData) as? Color {

            self.ambience = ambience
        }

        if let backgroundColorData = rawValue["backgroundColor"] as? Data,
            let backgroundColor = NSKeyedUnarchiver.unarchiveObject(with: backgroundColorData) as? Color {

            self.backgroundColor = backgroundColor
        }

        if let sceneFrameDict = rawValue["sceneFrame"] as? [String: Any],
            let minX = sceneFrameDict["minX"] as? Double,
            let maxX = sceneFrameDict["maxX"] as? Double,
            let minY = sceneFrameDict["minY"] as? Double,
            let maxY = sceneFrameDict["maxY"] as? Double,
            let zPlane = sceneFrameDict["zPlane"] as? Double,
            let width = sceneFrameDict["width"] as? Int,
            let height = sceneFrameDict["height"] as? Int,
            let aspectRatioRawValue = sceneFrameDict["aspectRatio"] as? Int,
            let aspectRatio = Frame.AspectRatio(rawValue: aspectRatioRawValue) {

            self.sceneFrame = Frame(minX: minX, maxX: maxX, minY: minY, maxY: maxY, zPlane: zPlane, width: width, height: height, aspectRatio: aspectRatio)
        }
    }

    var rawValue: RawValue {
        var raw: RawValue = [:]

        raw["eyePoint"] = NSKeyedArchiver.archivedData(withRootObject: eyePoint)

        raw["light"] = [
            "position": NSKeyedArchiver.archivedData(withRootObject: light.position),
            "color": NSKeyedArchiver.archivedData(withRootObject: light.color),
            "intensity": light.intensity.rawValue
        ]

        raw["ambience"] = NSKeyedArchiver.archivedData(withRootObject: ambience)

        raw["backgroundColor"] = NSKeyedArchiver.archivedData(withRootObject: backgroundColor)

        raw["sceneFrame"] = [
            "minX": sceneFrame.minX,
            "maxX": sceneFrame.maxX,
            "minY": sceneFrame.minY,
            "maxY": sceneFrame.maxY,
            "zPlane": sceneFrame.zPlane,
            "width": sceneFrame.width,
            "height": sceneFrame.height,
            "aspectRatio": sceneFrame.aspectRatio.rawValue
        ]

        return raw
    }
}
