//
//  UserDefaults.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/9/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import Foundation


extension UserDefaults {

    private enum Key: String {
        case eye = "com.pangburn.RayTracer.eye"
        case frame = "com.pangburn.RayTracer.frame"
        case light = "com.pangburn.RayTracer.light"
        case ambient = "com.pangburn.RayTracer.ambient"
    }

    var eye: Point? {
        get {
            guard let data = object(forKey: Key.eye.rawValue) as? Data else { return nil }
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? Point
        }
        set {
            if let newValue = newValue {
                let data = NSKeyedArchiver.archivedData(withRootObject: newValue)
                set(data, forKey: Key.eye.rawValue)
            } else {
                removeObject(forKey: Key.eye.rawValue)
            }
        }
    }


    var light: Light? {
        get {
            guard let data = dictionary(forKey: Key.light.rawValue) as? [String : Data],
                let position = NSKeyedUnarchiver.unarchiveObject(with: data["position"]!) as? Point,
                let color = NSKeyedUnarchiver.unarchiveObject(with: data["color"]!) as? Color else { return nil }
            return Light(position: position, color: color)
        }
        set {
            if let newValue = newValue {
                let data = [
                    "position" : NSKeyedArchiver.archivedData(withRootObject: newValue.position),
                    "color" : NSKeyedArchiver.archivedData(withRootObject: newValue.color)
                ]
                set(data, forKey: Key.light.rawValue)
            } else {
                removeObject(forKey: Key.light.rawValue)
            }
        }
    }

    var ambient: Color? {
        get {
            guard let data = object(forKey: Key.ambient.rawValue) as? Data else { return nil }
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? Color
        }
        set {
            if let newValue = newValue {
                let data = NSKeyedArchiver.archivedData(withRootObject: newValue)
                set(data, forKey: Key.ambient.rawValue)
            } else {
                removeObject(forKey: Key.ambient.rawValue)
            }
        }
    }
}
