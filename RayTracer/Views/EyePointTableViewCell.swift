//
//  EyePointTableViewCell.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/30/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import UIKit


protocol EyePointTableViewCellDelegate: class {
    func eyePointTableViewCellEyePointDidChange(_ cell: EyePointTableViewCell)
}


final class EyePointTableViewCell: ExpandableTableViewCell {

    weak var delegate: EyePointTableViewCellDelegate?

    var zCoordinate: Double {
        get {
            return Double(zSlider.value)
        }
        set {
            zSlider.value = Float(newValue)
            updateCoordinateLabel()
        }
    }

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = NSLocalizedString("Position", comment: "The title text for the position editing cell")
        }
    }

    @IBOutlet weak var coordinateLabel: UILabel!

    @IBOutlet weak var zLabel: UILabel! {
        didSet {
            zLabel.text = NSLocalizedString("z", comment: "The text for the point's z coordinate slider label")
        }
    }

    @IBOutlet weak var zSlider: UISlider!

    @IBOutlet weak var sliderWrapperView: UIView! {
        didSet {
            expandableView = sliderWrapperView
        }
    }

    @IBOutlet weak var sliderWrapperViewHeightConstraint: NSLayoutConstraint! {
        didSet {
            expandableViewHeightConstraint = sliderWrapperViewHeightConstraint
        }
    }

    private func updateCoordinateLabel() {
        let localizedZEquals = NSLocalizedString("z = ", comment: "The text describing the eye point's z coordinate")
        coordinateLabel.text = "\(localizedZEquals) \(zCoordinate.cleanValueOrSingleDecimalString)"
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        updateCoordinateLabel()
        delegate?.eyePointTableViewCellEyePointDidChange(self)
    }
}
