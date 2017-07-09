//
//  IdentifiableClass.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/8/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import Foundation


protocol IdentifiableClass: class {
    static var className: String { get }
}


extension IdentifiableClass {
    static var className: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
