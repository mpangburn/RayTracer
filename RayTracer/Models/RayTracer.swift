//
//  RayTracer.swift
//  RayTracer
//
//  Created by Michael Pangburn on 6/26/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import Foundation
import CoreData


/// Stores data for and performs ray tracing.
final class RayTracer {

    /// The shared RayTracer instance.
    static let shared = RayTracer()

    /// The spheres to cast rays on.
    var spheres: [Sphere] = {
        let context = PersistenceManager.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Sphere> = Sphere.fetchRequest()
        let dateSortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchRequest.sortDescriptors = [dateSortDescriptor]
        return (try? context.fetch(fetchRequest)) ?? []
        }() {
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
    var sceneNeedsRendering = true

    // Prevents access to any tracer other than the shared instance.
    private init() { }

    /**
     Casts all rays on the scene.
     - Returns: The image produced by casting all rays.
     */
    func castAllRays() -> Image {
        sceneNeedsRendering = false

        var pixels: [Color.PixelData] = []
        let frame = settings.sceneFrame
        let view = frame.view
        var width = frame.width
        var height = frame.height
        let dx = (view.maxX - view.minX) / Double(width)
        let dy = (view.maxY - view.minY) / Double(height)

        var y = view.maxY
        while y > view.minY {
            var x = view.minX
            while x < view.maxX {
                let direction = Vector(from: settings.eyePoint, to: Point(x: x, y: y, z: view.zPlane))
                let ray = Ray(initial: settings.eyePoint, direction: direction)
                let pixelData = cast(ray: ray)
                pixels.append(pixelData)
                x += dx
            }
            y -= dy
        }

        // Accounting for rounding errors. Marginally affects image size.
        let roundingError = pixels.count - (width * height)
        if roundingError == width {
            height += 1
        } else if roundingError == height {
            width += 1
        } else if roundingError > 0 {
            width += 1
            height += 1
        }

        return Image(pixelData: pixels, width: width, height: height)
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

