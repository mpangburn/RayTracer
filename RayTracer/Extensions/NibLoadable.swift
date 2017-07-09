//
//  NibLoadable.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/8/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import UIKit


protocol NibLoadable: IdentifiableClass {
    static func nib() -> UINib
}


extension NibLoadable {
    static func nib() -> UINib {
        return UINib(nibName: className, bundle: Bundle(for: self))
    }
}
