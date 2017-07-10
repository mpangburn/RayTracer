//
//  ColorView.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/8/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import UIKit

@IBDesignable class ColorView: UIView, IdentifiableClass, NibLoadable {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var innerColorView: UIView!
    @IBOutlet weak var innerColorViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var innerColorViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var innerColorViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var innerColorViewBottomConstraint: NSLayoutConstraint!

    @IBInspectable var color: UIColor {
        get {
            return innerColorView.backgroundColor ?? UIColor()
        }
        set {
            innerColorView.backgroundColor = newValue
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return borderView.layer.borderWidth
        }
        set {
            borderView.layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor {
        get {
            if let cgColor = borderView.layer.borderColor {
                return UIColor(cgColor: cgColor)
            } else {
                return UIColor()
            }
        }
        set {
            borderView.layer.borderColor = newValue.cgColor
        }
    }

    @IBInspectable var borderSpace: CGFloat {
        get {
            return innerColorViewTopConstraint.constant
        }
        set {
            innerColorViewTopConstraint.constant = newValue
            innerColorViewLeadingConstraint.constant = newValue
            innerColorViewTrailingConstraint.constant = newValue
            innerColorViewTrailingConstraint.constant = newValue
//            setNeedsDisplay()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        let view = viewFromNibForClass()
        view.frame = bounds

        view.autoresizingMask = [
            UIViewAutoresizing.flexibleWidth,
            UIViewAutoresizing.flexibleHeight
        ]

        addSubview(view)
    }

    private func viewFromNibForClass() -> UIView {
        return ColorView.nib().instantiate(withOwner: self, options: nil).first as! UIView
    }

}
