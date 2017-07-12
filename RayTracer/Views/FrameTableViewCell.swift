//
//  FrameTableViewCell.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/10/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import UIKit


protocol FrameTableViewCellDelegate: class {
    func frameTableViewCellFrameDidChange(_ cell: FrameTableViewCell)
}


class FrameTableViewCell: ExpandableTableViewCell {

    weak var delegate: FrameTableViewCellDelegate?

    var sceneFrame: Frame {
        get {
            return Frame(minX: Double(minXSlider.value),
                         maxX: Double(maxXSlider.value),
                         minY: Double(minYSlider.value),
                         maxY: Double(maxYSlider.value),
                         width: Int(widthSlider.value),
                         height: Int(heightSlider.value))
        }
        set {
            minXSlider.value = Float(newValue.minX)
            maxXSlider.value = Float(newValue.maxX)
            minYSlider.value = Float(newValue.minY)
            maxYSlider.value = Float(newValue.maxY)
            widthSlider.value = Float(newValue.width)
            heightSlider.value = Float(newValue.height)
            updateMeasurementsLabel()
        }
    }

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = NSLocalizedString("Frame", comment: "The title text for the frame editing cell")
        }
    }

    @IBOutlet weak var measurementsLabel: UILabel!

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

    @IBOutlet weak var minXSlider: UISlider!
    @IBOutlet weak var maxXSlider: UISlider!
    @IBOutlet weak var minYSlider: UISlider!
    @IBOutlet weak var maxYSlider: UISlider!
    @IBOutlet weak var widthSlider: UISlider!
    @IBOutlet weak var heightSlider: UISlider!

    private func updateMeasurementsLabel() {
        let frame = self.sceneFrame
        measurementsLabel.text = "(\(Int(frame.minX)), \(Int(frame.maxX))) × (\(Int(frame.minY)), \(Int(frame.maxY))) | \(frame.width) × \(frame.height)"
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        updateMeasurementsLabel()
        delegate?.frameTableViewCellFrameDidChange(self)
    }
}
