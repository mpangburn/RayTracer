//
//  ColorTableViewCell.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/8/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import UIKit


protocol ColorTableViewCellDelegate: class {
    func colorTableViewCellColorDidChange(_ cell: ColorTableViewCell)
}


final class ColorTableViewCell: ExpandableTableViewCell {

    weak var delegate: ColorTableViewCellDelegate?

    var color: Color {
        get {
            return Color(red: Double(redSlider.value), green: Double(greenSlider.value), blue: Double(blueSlider.value))
        }
        set {
            redSlider.value = Float(newValue.red)
            greenSlider.value = Float(newValue.green)
            blueSlider.value = Float(newValue.blue)
            updateColorView()
        }
    }

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = NSLocalizedString("Color", comment: "The title text for the color editing cell")

        }
    }

    @IBOutlet weak var colorView: UIView! {
        didSet {
            colorView.layer.borderColor = UIColor.black.cgColor
            colorView.layer.borderWidth = 1.0
        }
    }

    @IBOutlet weak var redLabel: UILabel! {
        didSet {
            redLabel.text = NSLocalizedString("R", comment: "The text for the red color component slider label")
        }
    }

    @IBOutlet weak var greenLabel: UILabel! {
        didSet {
            greenLabel.text = NSLocalizedString("G", comment: "The text for the green color component slider label")
        }
    }

    @IBOutlet weak var blueLabel: UILabel! {
        didSet {
            blueLabel.text = NSLocalizedString("B", comment: "The text for the blue color component slider label")
        }
    }

    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!

    @IBOutlet weak var colorSliderWrapperView: UIView! {
        didSet {
            expandableView = colorSliderWrapperView
        }
    }

    @IBOutlet weak var colorSliderWrapperViewHeightConstraint: NSLayoutConstraint! {
        didSet {
            expandableViewHeightConstraint = colorSliderWrapperViewHeightConstraint
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            updateColorView()
        }
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)

        if highlighted {
            updateColorView()
        }
    }

    private func updateColorView() {
        colorView.backgroundColor = UIColor(color)
    }
    
    @IBAction func colorChanged(_ sender: Any) {
        updateColorView()
        delegate?.colorTableViewCellColorDidChange(self)
    }
}
