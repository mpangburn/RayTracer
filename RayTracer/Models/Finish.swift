//
//  Finish.swift
//  RayTracer
//
//  Created by Michael Pangburn on 6/26/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import Foundation


/// Describes how an object interacts with light.
class Finish: NSObject, NSCoding {

    /// The percentage of ambient light reflected by the finish.
    var ambient: Double

    /// The percentage of diffuse light reflected by the finish.
    var diffuse: Double

    /// The percentage of specular light reflected by the finish.
    var specular: Double

    /// The modeled roughness of the finish, which affects the spread of the specular light across the object.
    var roughness: Double

    /**
     Creates a finish with the attributes.
     - Parameters:
        - ambient: The percentage of ambient light reflected by the finish.
        - diffuse: The percentage of diffuse light reflected by the finish
        - specular: The percentage of specular light reflected by the finish.
        - roughness: The modeled roughness of the finish.
     */
    init(ambient: Double, diffuse: Double, specular: Double, roughness: Double) {
        self.ambient = ambient
        self.diffuse = diffuse
        self.specular = specular
        self.roughness = roughness
    }

    private enum CodingKey: String {
        case ambient, diffuse, specular, roughness
    }

    required convenience init?(coder aDecoder: NSCoder) {
        let ambient = aDecoder.decodeDouble(forKey: CodingKey.ambient.rawValue)
        let diffuse = aDecoder.decodeDouble(forKey: CodingKey.diffuse.rawValue)
        let specular = aDecoder.decodeDouble(forKey: CodingKey.specular.rawValue)
        let roughness = aDecoder.decodeDouble(forKey: CodingKey.roughness.rawValue)
        self.init(ambient: ambient, diffuse: diffuse, specular: specular, roughness: roughness)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.ambient, forKey: CodingKey.ambient.rawValue)
        aCoder.encode(self.diffuse, forKey: CodingKey.diffuse.rawValue)
        aCoder.encode(self.specular, forKey: CodingKey.specular.rawValue)
        aCoder.encode(self.roughness, forKey: CodingKey.roughness.rawValue)
    }
}


// MARK: - Finish constants
extension Finish {

    /// No finish.
    static var none: Finish {
        return Finish(ambient: 0, diffuse: 0, specular: 0, roughness: 0)
    }
}


extension Finish {
    static func == (lhs: Finish, rhs: Finish) -> Bool {
        return lhs.ambient == rhs.ambient &&
            lhs.diffuse == rhs.diffuse &&
            lhs.specular == rhs.specular &&
            lhs.roughness == rhs.roughness
    }
}


extension Finish {
    override var description: String {
        return "Finish(ambient: \(self.ambient), diffuse: \(self.diffuse), specular: \(self.specular), roughness: \(self.roughness)))"
    }
}

