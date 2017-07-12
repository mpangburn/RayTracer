//
//  FrameSizeTableViewCell.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/11/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import UIKit


protocol FrameSizeTableViewCellDelegate: class {
    func frameSizeTableViewCellFrameSizeDidChange(_ cell: FrameSizeTableViewCell)
}


class FrameSizeTableViewCell: ExpandableTableViewCell {

    weak var delegate: FrameSizeTableViewCellDelegate?

    var frameSize: Frame.Size {
        get {
            return Frame.Size(width: Int(widthSlider.value), height: Int(heightSlider.value))
        }
        set {
            widthSlider.value = Float(newValue.width)
            heightSlider.value = Float(newValue.height)
            updateSizeLabel()
        }
    }

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = NSLocalizedString("Size", comment: "The title text for the frame size editing cell")
        }
    }

    @IBOutlet weak var sizeLabel: UILabel!

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

    @IBOutlet weak var widthSlider: UISlider!
    @IBOutlet weak var heightSlider: UISlider!

    func updateSizeLabel() {
        let frameSize = self.frameSize
        sizeLabel.text = "\(frameSize.width) × \(frameSize.height)"
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        updateSizeLabel()
        delegate?.frameSizeTableViewCellFrameSizeDidChange(self)
    }
}
