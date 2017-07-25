//
//  RayTracer.swift
//  RayTracer
//
//  Created by Michael Pangburn on 6/26/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import Foundation


/// Stores data for and performs ray tracing.
final class RayTracer {

    /// The shared RayTracer instance.
    static var shared = RayTracer()

    /// The spheres to cast rays on.
    var spheres: [Sphere] = [] {
        didSet {
            sceneNeedsRendering = true
        }
    }

    /// The ray tracing settings to be used in creating the scene.
    var settings = UserDefaults.standard.rayTracerSettings ?? RayTracerSettings() {
        didSet {
            sceneNeedsRendering = true
        }
    }

    /// Represents whether changes have been made to the scene since its last render.
    var sceneNeedsRendering = false

    /**
     Casts all rays on the scene.
     - Returns: The image produced by casting all rays.
     */
    func castAllRays() -> Image {
        sceneNeedsRendering = false

        var pixels: [Color.PixelData] = []
        let frame = settings.sceneFrame
        let xOffset = (frame.view.maxX - frame.view.minX) / Double(frame.width)
        let yOffset = (frame.view.maxY - frame.view.minY) / Double(frame.height)

        var y = frame.view.maxY
        while y > frame.view.minY {
            var x = frame.view.minX
            while x < frame.view.maxX {
                let direction = Vector(from: settings.eyePoint, to: Point(x: x, y: y, z: frame.view.zPlane))
                let ray = Ray(initial: settings.eyePoint, direction: direction)
                let pixelData = cast(ray: ray)
                pixels.append(pixelData)
                x += xOffset
            }
            y -= yOffset
        }

//        pixels = Array(pixels.prefix(upTo: frame.width * frame.height))
//        pixels = Array(pixels.suffix(frame.width * frame.height))
        let areaDifference = pixels.count - (frame.width * frame.height)
        let halfAreaDifference = areaDifference / 2
        pixels = Array(pixels.dropFirst(halfAreaDifference))
        pixels = Array(pixels.dropLast(areaDifference - halfAreaDifference))

        return Image(pixelData: pixels, width: frame.width, height: frame.height)
    }

    /**
     Casts the ray on the scene.
     - Parameter ray: The ray to cast.
     - Returns: The pixel data for the color produced when casting the ray on the scene.
     */
    func cast(ray: Ray) -> Color.PixelData {
        guard let intersection = ray.closestIntersection(with: spheres) else {
            return settings.backgroundColor.pixelData
        }

        let closestSphere = intersection.sphere
        let ambient = closestSphere.finish.ambient
        let diffuse = computeDiffuseComponents(at: intersection)
        let specular = computeSpecularComponents(at: intersection)
        let red = closestSphere.color.red * (settings.ambience.red * ambient) + diffuse.red + specular.red
        let green = closestSphere.color.green * (settings.ambience.green * ambient) + diffuse.green + specular.green
        let blue = closestSphere.color.blue * (settings.ambience.blue * ambient) + diffuse.blue + specular.blue

        return Color(red: red, green: green, blue: blue).pixelData
    }

    /// Computes the additive diffuse components for the color produced when casting a ray.
    private func computeDiffuseComponents(at intersection: Ray.Intersection) -> Color {
        let (sphere, intersectionPoint) = intersection
        let normalToSphere = sphere.normal(at: intersectionPoint)
        let pointJustOffSphere = intersectionPoint.translate(by: normalToSphere * 0.01)
        let light = settings.light
        let vectorFromPointJustOffSphereToLight = Vector(from: pointJustOffSphere, to: light.position)
        let lightDirection = vectorFromPointJustOffSphereToLight.normalized()
        let rayToLight = Ray(initial: pointJustOffSphere, direction: lightDirection)
        let distanceToLight = vectorFromPointJustOffSphereToLight.length
        let rayToLightIntersections = rayToLight.intersections(with: spheres)

        var lightIsObscured = false
        for intersection in rayToLightIntersections {
            let distanceToSphere = intersection.point.distance(from: rayToLight.initial)
            if distanceToSphere < distanceToLight {
                lightIsObscured = true
                break
            }
        }

        let dotProduct = normalToSphere • lightDirection
        if lightIsObscured || dotProduct <= 0 {
            return Color.black
        } else {
            let base = dotProduct * sphere.finish.diffuse
            let redDiffuse = light.effectiveColor.red * sphere.color.red * base
            let greenDiffuse = light.effectiveColor.green * sphere.color.green * base
            let blueDiffuse = light.effectiveColor.blue * sphere.color.blue * base
            return Color(red: redDiffuse, green: greenDiffuse, blue: blueDiffuse)
        }
    }

    /// Computes the additive specular components for the color produced when casting a ray.
    private func computeSpecularComponents(at intersection: Ray.Intersection) -> Color {
        let (sphere, intersectionPoint) = intersection
        let normalToSphere = sphere.normal(at: intersectionPoint)
        let pointJustOffSphere = intersectionPoint.translate(by: normalToSphere * 0.01)
        let light = settings.light
        let vectorFromPointJustOffSphereToLight = Vector(from: pointJustOffSphere, to: light.position)
        let lightDirection = vectorFromPointJustOffSphereToLight.normalized()
        let dotProduct = normalToSphere • lightDirection

        let reflectionVector = lightDirection - 2 * dotProduct * normalToSphere
        let eyePointDirection = Vector(from: settings.eyePoint, to: pointJustOffSphere).normalized()
        let specularIntensity = reflectionVector • eyePointDirection
        if specularIntensity <= 0 {
            return Color.black
        } else {
            let base = sphere.finish.specular * pow(specularIntensity, 1 / sphere.finish.roughness)
            let redSpecular = light.effectiveColor.red * base
            let greenSpecular = light.effectiveColor.green * base
            let blueSpecular = light.effectiveColor.blue * base
            return Color(red: redSpecular, green: greenSpecular, blue: blueSpecular)
        }
    }
}

