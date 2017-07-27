//
//  FrameSizeTableViewCell.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/11/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import UIKit


protocol FrameSizeTableViewCellDelegate: class {
    func frameSizeTableViewCellWidthDidChange(_ cell: FrameSizeTableViewCell)
    func frameSizeTableViewCellHeightDidChange(_ cell: FrameSizeTableViewCell)
}


final class FrameSizeTableViewCell: ExpandableTableViewCell {

    weak var delegate: FrameSizeTableViewCellDelegate?

    var width: Int {
        get {
            return Int(widthSlider.value)
        }
        set {
            widthSlider.value = Float(newValue)
            updateSizeLabel()
        }
    }

    var height: Int {
        get {
            return Int(heightSlider.value)
        }
        set {
            heightSlider.value = Float(newValue)
            updateSizeLabel()
        }
    }

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = NSLocalizedString("Size", comment: "The title text for the frame size editing cell")
        }
    }

    @IBOutlet weak var sizeLabel: UILabel!

    @IBOutlet weak var widthLabel: UILabel! {
        didSet {
            widthLabel.text = NSLocalizedString("width", comment: "The text for the frame width slider label")
        }
    }

    @IBOutlet weak var heightLabel: UILabel! {
        didSet {
            heightLabel.text = NSLocalizedString("height", comment: "The text for the frame height slider label")
        }
    }

    @IBOutlet weak var widthSlider: UISlider!
    @IBOutlet weak var heightSlider: UISlider!

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

    private func updateSizeLabel() {
        sizeLabel.text = "\(width) × \(height)"
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        updateSizeLabel()
        
        switch sender {
        case widthSlider:
            delegate?.frameSizeTableViewCellWidthDidChange(self)
        case heightSlider:
            delegate?.frameSizeTableViewCellHeightDidChange(self)
        default:
            break
        }
    }
}
