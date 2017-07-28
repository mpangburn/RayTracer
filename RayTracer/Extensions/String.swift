//
//  String.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/28/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import Foundation


// MARK: - Multi line strings (since Swift 4 isn't here yet!)
extension String {

    init(_ lines: String..., separator: String = "\n"){
        self = ""
        for (index, item) in lines.enumerated() {
            self += item
            if index < lines.count - 1 {
                self += separator
            }
        }
    }
}
