//
//  File.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/8/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import UIKit


extension UIColor {

    /**
     Creates a UIColor from the color components.
     - Parameter color: The color data from which to create the UIColor.
     */
    public convenience init(_ color: Color) {
        self.init(red: CGFloat(color.red),
                  green: CGFloat(color.green),
                  blue: CGFloat(color.blue),
                  alpha: CGFloat(color.alpha))
    }
}
