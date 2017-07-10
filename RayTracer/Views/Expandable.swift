//
//  Expandable.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/8/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import UIKit


protocol Expandable: class {
    var isExpanded: Bool { get set }
//    var viewForDeterminingHeight: UIView { get set }
//    var expandedHeight: CGFloat { get set }
//    var heightLayoutConstraint: NSLayoutConstraint { get set }
}


//extension Expandable {
//    var isExpanded: Bool {
//        get {
//            return viewForDeterminingHeight.alpha == 1
//        }
//        set {
//            if newValue {
//                UIView.animate(withDuration: 1) {
//                    self.viewForDeterminingHeight.alpha = 1
//                    self.heightLayoutConstraint.constant = self.expandedHeight
//                }
//
//            } else {
//                viewForDeterminingHeight.alpha = 0
//                heightLayoutConstraint.constant = 0
//            }
//        }
//    }
//}
