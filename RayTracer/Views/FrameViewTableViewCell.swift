//
//  FrameViewTableViewCell.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/10/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import UIKit


protocol FrameViewTableViewCellDelegate: class {
    func frameViewTableViewCellFrameViewDidChange(_ cell: FrameViewTableViewCell)
}


final class FrameViewTableViewCell: ExpandableTableViewCell {

    weak var delegate: FrameViewTableViewCellDelegate?

    var frameView: Frame.View {
        get {
            return Frame.View(minX: Double(minXSlider.value),
                         maxX: Double(maxXSlider.value),
                         minY: Double(minYSlider.value),
                         maxY: Double(maxYSlider.value),
                         zPlane: Double(zPlaneSlider.value))
        }
        set {
            minXSlider.value = Float(newValue.minX)
            maxXSlider.value = Float(newValue.maxX)
            minYSlider.value = Float(newValue.minY)
            maxYSlider.value = Float(newValue.maxY)
            zPlaneSlider.value = Float(newValue.zPlane)
            updateMeasurementsLabel()
        }
    }

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = NSLocalizedString("View", comment: "The title text for the frame view editing cell")
        }
    }

    @IBOutlet weak var measurementsLabel: UILabel!

    @IBOutlet weak var minXLabel: UILabel! {
        didSet {
            minXLabel.text = NSLocalizedString("min x", comment: "The text for the frame view's minimum x coordinate slider label")
        }
    }

    @IBOutlet weak var maxXLabel: UILabel! {
        didSet {
            maxXLabel.text = NSLocalizedString("max x", comment: "The text for the frame view's maximum x coordinate slider label")
        }
    }

    @IBOutlet weak var minYLabel: UILabel! {
        didSet {
            minYLabel.text = NSLocalizedString("min y", comment: "The text for the frame view's minimum y coordinate slider label")
        }
    }

    @IBOutlet weak var maxYLabel: UILabel! {
        didSet {
            maxYLabel.text = NSLocalizedString("max y", comment: "The text for the frame view's maximum y coordinate slider label")
        }
    }

    @IBOutlet weak var zPlaneLabel: UILabel! {
        didSet {
            zPlaneLabel.text = NSLocalizedString("z-plane", comment: "The text for the frame view's z-plane coordinate slider label")
        }
    }

    @IBOutlet weak var minXSlider: UISlider!
    @IBOutlet weak var maxXSlider: UISlider!
    @IBOutlet weak var minYSlider: UISlider!
    @IBOutlet weak var maxYSlider: UISlider!
    @IBOutlet weak var zPlaneSlider: UISlider!

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

    private func updateMeasurementsLabel() {
        let frameView = self.frameView
        let localizedZPlaneString = NSLocalizedString("on z = \(frameView.zPlane.cleanValueOrSingleDecimalString)", comment: "The text describing the frame view's z-plane")
        measurementsLabel.text = "(\(frameView.minX.cleanValueOrSingleDecimalString), \(frameView.maxX.cleanValueOrSingleDecimalString)) × (\(frameView.minY.cleanValueOrSingleDecimalString), \(frameView.maxY.cleanValueOrSingleDecimalString)) \(localizedZPlaneString)"
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        updateMeasurementsLabel()
        delegate?.frameViewTableViewCellFrameViewDidChange(self)
    }
}
