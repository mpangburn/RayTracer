//
//  FrameViewTableViewCell.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/10/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import UIKit


protocol FrameViewTableViewCellDelegate: class {
    func frameViewTableViewCellMinXDidChange(_ cell: FrameViewTableViewCell)
    func frameViewTableViewCellMaxXDidChange(_ cell: FrameViewTableViewCell)
    func frameViewTableViewCellMinYDidChange(_ cell: FrameViewTableViewCell)
    func frameViewTableViewCellMaxYDidChange(_ cell: FrameViewTableViewCell)
    func frameViewTableViewCellZPlaneDidChange(_ cell: FrameViewTableViewCell)
}


final class FrameViewTableViewCell: ExpandableTableViewCell {

    weak var delegate: FrameViewTableViewCellDelegate?

    var minX: Double {
        get {
            return Double(minXSlider.value)
        }
        set {
            minXSlider.value = Float(newValue)
            updateCoordinatesLabel()
        }
    }

    var maxX: Double {
        get {
            return Double(maxXSlider.value)
        }
        set {
            maxXSlider.value = Float(newValue)
            updateCoordinatesLabel()
        }
    }

    var minY: Double {
        get {
            return Double(minYSlider.value)
        }
        set {
            minYSlider.value = Float(newValue)
            updateCoordinatesLabel()
        }
    }

    var maxY: Double {
        get {
            return Double(maxYSlider.value)
        }
        set {
            maxYSlider.value = Float(newValue)
            updateCoordinatesLabel()
        }
    }

    var zPlane: Double {
        get {
            return Double(zPlaneSlider.value)
        }
        set {
            zPlaneSlider.value = Float(newValue)
            updateCoordinatesLabel()
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

    private func updateCoordinatesLabel() {
        let localizedZPlaneString = NSLocalizedString("on z = ", comment: "The text describing the frame view's z-plane")
        measurementsLabel.text = "(\(minX.cleanValueOrSingleDecimalString), \(maxX.cleanValueOrSingleDecimalString)) × (\(minY.cleanValueOrSingleDecimalString), \(maxY.cleanValueOrSingleDecimalString)) \(localizedZPlaneString)\(zPlane.cleanValueOrSingleDecimalString)"
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        updateCoordinatesLabel()

        switch sender {
        case minXSlider:
            delegate?.frameViewTableViewCellMinXDidChange(self)
        case maxXSlider:
            delegate?.frameViewTableViewCellMaxXDidChange(self)
        case minYSlider:
            delegate?.frameViewTableViewCellMinYDidChange(self)
        case maxYSlider:
            delegate?.frameViewTableViewCellMaxYDidChange(self)
        case zPlaneSlider:
            delegate?.frameViewTableViewCellZPlaneDidChange(self)
        default:
            break
        }
    }
}
