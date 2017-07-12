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
    var sceneFrame = Frame(view: Frame.View(minX: -10, maxX: 10, minY: -7.5, maxY: 7.5, zPlane: 0), size: Frame.Size(width: 512, height: 384))
}


extension RayTracerSettings: RawRepresentable {
    typealias RawValue = [String: Any]

    init?(rawValue: RawValue) {
        guard let eyePointData = rawValue["eyePoint"] as? Data,
            let eyePoint = NSKeyedUnarchiver.unarchiveObject(with: eyePointData) as? Point else {
                return nil
        }

        self.eyePoint = eyePoint

        guard let lightDict = rawValue["light"] as? [String: Any],
            let lightPositionData = lightDict["position"] as? Data,
            let lightPosition = NSKeyedUnarchiver.unarchiveObject(with: lightPositionData) as? Point,
            let lightColorData = lightDict["color"] as? Data,
            let lightColor = NSKeyedUnarchiver.unarchiveObject(with: lightColorData) as? Color,
            let intensityRawValue = lightDict["intensity"] as? Double,
            let intensity = Light.Intensity(rawValue: intensityRawValue) else {
                return nil
        }

        self.light = Light(position: lightPosition, color: lightColor, intensity: intensity)

        guard let ambienceData = rawValue["ambience"] as? Data,
            let ambience = NSKeyedUnarchiver.unarchiveObject(with: ambienceData) as? Color else {
                return nil
        }

        self.ambience = ambience

        guard let sceneFrameDict = rawValue["sceneFrame"] as? [String: Any],
            let minX = sceneFrameDict["minX"] as? Double,
            let maxX = sceneFrameDict["maxX"] as? Double,
            let minY = sceneFrameDict["minY"] as? Double,
            let maxY = sceneFrameDict["maxY"] as? Double,
            let zPlane = sceneFrameDict["zPlane"] as? Double,
            let width = sceneFrameDict["width"] as? Int,
            let height = sceneFrameDict["height"] as? Int else {
                return nil
        }

        self.sceneFrame = Frame(view: Frame.View(minX: minX, maxX: maxX, minY: minY, maxY: maxY, zPlane: zPlane), size: Frame.Size(width: width, height: height))
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

        raw["sceneFrame"] = [
            "minX": sceneFrame.view.minX,
            "maxX": sceneFrame.view.maxX,
            "minY": sceneFrame.view.minY,
            "maxY": sceneFrame.view.maxY,
            "zPlane": sceneFrame.view.zPlane,
            "width": sceneFrame.size.width,
            "height": sceneFrame.size.height
        ]

        return raw
    }
}
