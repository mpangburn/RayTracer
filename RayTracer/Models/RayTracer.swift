//
//  RayTracer.swift
//  RayTracer
//
//  Created by Michael Pangburn on 6/26/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import Foundation


/// Contains functions for ray tracing.
class RayTracer {

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
            UserDefaults.standard.rayTracerSettings = settings
            sceneNeedsRendering = true
        }
    }

    /// Represents whether changes have been made to the scene since its last render.
    var sceneNeedsRendering = false

    /**
     Casts all rays on the scene.
     */
    func castAllRays() -> Image {
        sceneNeedsRendering = false

        var pixels: [Color.PixelData] = []
        let frame = settings.sceneFrame
        let xOffset = (frame.maxX - frame.minX) / Double(frame.width)
        let yOffset = (frame.maxY - frame.minY) / Double(frame.height)

        var y = frame.maxY
        while y > frame.minY {
            var x = frame.minX
            while x < frame.maxX {
                let direction = Vector(from: settings.eye, to: Point(x: x, y: y, z: 0))
                let ray = Ray(initial: settings.eye, direction: direction)
                let pixelData = RayTracer.cast(ray: ray, on: spheres, with: settings.ambient, under: settings.light, viewedFrom: settings.eye)
                pixels.append(pixelData)
                x += xOffset
            }
            y -= yOffset
        }

        pixels = Array(pixels.prefix(upTo: frame.width * frame.height))
        return Image(pixelData: pixels, width: frame.width, height: frame.height)
    }

    /**
     Casts all rays on the scene.
     - Parameters:
        - spheres: The spheres to cast the rays on.
        - frame: The frame of the scene.
        - ambientLightColor: The ambient light color of the scene.
        - light: The light illuminating the scene.
        - eye: The point from which the scene is viewed.
     - Returns: The data for the image produced when casting the rays on the scene.
     */
    static func castAllRays(on spheres: [Sphere], in frame: Frame, with ambientLightColor: Color, under light: Light, viewedFrom eye: Point) -> Image {
        var pixels: [Color.PixelData] = []

        let xOffset = (frame.maxX - frame.minX) / Double(frame.width)
        let yOffset = (frame.maxY - frame.minY) / Double(frame.height)

        var y = frame.maxY
        while y > frame.minY {
            var x = frame.minX
            while x < frame.maxX {
                let direction = Vector(from: eye, to: Point(x: x, y: y, z: 0))
                let ray = Ray(initial: eye, direction: direction)
                let pixelData = cast(ray: ray, on: spheres, with: ambientLightColor, under: light, viewedFrom: eye)
                pixels.append(pixelData)
                x += xOffset
            }
            y -= yOffset
        }

        pixels = Array(pixels.prefix(upTo: frame.width * frame.height))
        return Image(pixelData: pixels, width: frame.width, height: frame.height)
    }

    /**
     Casts the ray on the scene.
     - Parameters:
        - ray: The ray to cast.
        - spheres: The spheres to cast the ray on.
        - ambientLightColor: The ambient light color of the scene.
        - light: The light illuminating the scene.
        - eye: The point from which the scene is viewed.
     - Returns: The pixel data for the color produced when casting the ray on the scene.
     */
    static func cast(ray: Ray, on spheres: [Sphere], with ambientLightColor: Color, under light: Light, viewedFrom eye: Point) -> Color.PixelData {
        guard let (closestSphere, intersectionPoint) = ray.closestIntersection(with: spheres) else {
            return Color.white.pixelData
        }

        let ambient = closestSphere.finish.ambient
        let diffuse = computeDiffuseComponents(spheres: spheres, closestSphere: closestSphere, intersectionPoint: intersectionPoint, light: light)
        let specular = computeSpecularComponents(sphere: closestSphere, intersectionPoint: intersectionPoint, light: light, eye: eye)
        let red = closestSphere.color.red * ambientLightColor.red * ambient + diffuse.red + specular.red
        let green = closestSphere.color.green * ambientLightColor.green * ambient + diffuse.green + specular.green
        let blue = closestSphere.color.blue * ambientLightColor.blue * ambient + diffuse.blue + specular.blue

        return Color(red: red, green: green, blue: blue).pixelData
    }

    /// Computes the additive diffuse components for the color produced when casting a ray.
    private static func computeDiffuseComponents(spheres: [Sphere], closestSphere: Sphere, intersectionPoint: Point, light: Light) -> Color {
        let normalToSphere = closestSphere.normal(at: intersectionPoint)
        let pointJustOffSphere = intersectionPoint.translate(by: normalToSphere * 0.01)
        let vectorFromPointJustOffSphereToLight = Vector(from: pointJustOffSphere, to: light.position)
        let lightDirection = vectorFromPointJustOffSphereToLight.normalized()
        let rayToLight = Ray(initial: pointJustOffSphere, direction: lightDirection)
        let distanceToLight = vectorFromPointJustOffSphereToLight.length
        let rayToLightIntersections = rayToLight.intersections(with: spheres)

        var lightIsObscured = false
        if rayToLightIntersections.count > 0 {
            for intersection in rayToLightIntersections {
                let distanceToSphere = intersection.point.distance(from: rayToLight.initial)
                if distanceToSphere < distanceToLight {
                    lightIsObscured = true
                    break
                }
            }
        }

        let dotProduct = normalToSphere • lightDirection
        let diffuseComponents: Color
        if lightIsObscured || dotProduct <= 0 {
            diffuseComponents = Color.black
        } else {
            let base = dotProduct * closestSphere.finish.diffuse
            let redDiffuse = light.color.red * closestSphere.color.red * base
            let greenDiffuse = light.color.green * closestSphere.color.green * base
            let blueDiffuse = light.color.blue * closestSphere.color.blue * base
            diffuseComponents = Color(red: redDiffuse, green: greenDiffuse, blue: blueDiffuse)
        }

        return diffuseComponents
    }

    /// Computes the additive specular components for the color produced when casting a ray.
    private static func computeSpecularComponents(sphere: Sphere, intersectionPoint: Point, light: Light, eye: Point) -> Color {
        let normalToSphere = sphere.normal(at: intersectionPoint)
        let pointJustOffSphere = intersectionPoint.translate(by: normalToSphere * 0.01)
        let vectorFromPointJustOffSphereToLight = Vector(from: pointJustOffSphere, to: light.position)
        let lightDirection = vectorFromPointJustOffSphereToLight.normalized()
        let dotProduct = normalToSphere • lightDirection

        let reflectionVector = lightDirection - 2 * dotProduct * normalToSphere
        let eyeDirection = Vector(from: eye, to: pointJustOffSphere).normalized()
        let specularIntensity = reflectionVector • eyeDirection
        let specularComponents: Color
        if specularIntensity <= 0 {
            specularComponents = Color.black
        } else {
            let base = sphere.finish.specular * pow(specularIntensity, 1 / sphere.finish.roughness)
            let redSpecular = light.color.red * base
            let greenSpecular = light.color.green * base
            let blueSpecular = light.color.blue * base
            specularComponents = Color(red: redSpecular, green: greenSpecular, blue: blueSpecular)
        }

        return specularComponents
    }
}
