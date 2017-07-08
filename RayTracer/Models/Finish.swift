//
//  Finish.swift
//  RayTracer
//
//  Created by Michael Pangburn on 6/26/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import Foundation


/// Describes how an object interacts with light.
public class Finish: NSObject {

    /// The percentage of ambient light reflected by the finish.
    public var ambient: Double

    /// The percentage of diffuse light reflected by the finish.
    public var diffuse: Double

    /// The percentage of specular light reflected by the finish.
    public var specular: Double

    /// The modeled roughness of the finish.
    public var roughness: Double

    /**
     Creates a finish with the attributes.
     - Parameters:
        - ambient: The percentage of ambient light reflected by the finish.
        - diffuse: The percentage of diffuse light reflected by the finish
        - specular: The percentage of specular light reflected by the finish.
        - roughness: The modeled roughness of the finish.
     */
    public init(ambient: Double, diffuse: Double, specular: Double, roughness: Double) {
        self.ambient = ambient
        self.diffuse = diffuse
        self.specular = specular
        self.roughness = roughness
    }
}


// MARK: - Equatability
extension Finish {
    public static func == (lhs: Finish, rhs: Finish) -> Bool {
        return lhs.ambient == rhs.ambient &&
            lhs.diffuse == rhs.diffuse &&
            lhs.specular == rhs.specular &&
            lhs.roughness == rhs.roughness
    }
}


// MARK: - Description
extension Finish {
    override public var description: String {
        return "Finish(ambient: \(self.ambient), diffuse: \(self.diffuse), specular: \(self.specular), roughness: \(self.roughness)))"
    }
}

