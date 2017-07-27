//
//  PointTableViewCell.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/8/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import UIKit


protocol PointTableViewCellDelegate: class {
    func pointTableViewCellPointDidChange(_ cell: PointTableViewCell)
}


final class PointTableViewCell: ExpandableTableViewCell {

    weak var delegate: PointTableViewCellDelegate?

    var point: Point {
        get {
            return Point(x: Double(xSlider.value).roundedTo(decimalPlaces: 1),
                         y: Double(ySlider.value).roundedTo(decimalPlaces: 1),
                         z: Double(zSlider.value).roundedTo(decimalPlaces: 1))
        }
        set {
            xSlider.value = Float(newValue.x)
            ySlider.value = Float(newValue.y)
            zSlider.value = Float(newValue.z)
            updateCoordinatesLabel()
        }
    }

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = NSLocalizedString("Position", comment: "The title text for the position editing cell")
        }
    }

    @IBOutlet weak var coordinatesLabel: UILabel!

    @IBOutlet weak var xLabel: UILabel! {
        didSet {
            xLabel.text = NSLocalizedString("x", comment: "The text for the point's x coordinate slider label")
        }
    }

    @IBOutlet weak var yLabel: UILabel! {
        didSet {
            yLabel.text = NSLocalizedString("y", comment: "The text for the point's y coordinate slider label")
        }
    }

    @IBOutlet weak var zLabel: UILabel! {
        didSet {
            zLabel.text = NSLocalizedString("z", comment: "The text for the point's z coordinate slider label")
        }
    }

    @IBOutlet weak var xSlider: UISlider!
    @IBOutlet weak var ySlider: UISlider!
    @IBOutlet weak var zSlider: UISlider!

    @IBOutlet weak var slidersWrapperView: UIView! {
        didSet {
            expandableView = slidersWrapperView
        }
    }

    @IBOutlet weak var slidersWrapperViewHeightConstraint: NSLayoutConstraint! {
        didSet {
            expandableViewHeightConstraint = slidersWrapperViewHeightConstraint
        }
    }


    private func updateCoordinatesLabel() {
        let point = self.point
        coordinatesLabel.text = "(\(point.x), \(point.y), \(point.z))"
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        updateCoordinatesLabel()
        delegate?.pointTableViewCellPointDidChange(self)
    }
}
