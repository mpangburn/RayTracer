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
        case rayTracerSettings = "com.pangburn.RayTracer.rayTracerSettings"
    }

    var rayTracerSettings: RayTracerSettings? {
        get {
            if let rawValue = dictionary(forKey: Key.rayTracerSettings.rawValue) {
                return RayTracerSettings(rawValue: rawValue)
            } else {
                return nil
            }
        }
        set {
            set(newValue?.rawValue, forKey: Key.rayTracerSettings.rawValue)
        }
    }
}
