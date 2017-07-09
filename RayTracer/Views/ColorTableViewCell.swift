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


class ColorTableViewCell: UITableViewCell {

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

    @IBOutlet weak var colorView: UIView!   //ColorView!
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var colorSliderWrapperView: UIView!
    @IBOutlet weak var colorSliderWrapperViewHeightConstraint: NSLayoutConstraint!
//    @IBOutlet weak var colorSliderStackView: UIStackView!
//    @IBOutlet weak var colorSliderStackViewHeightConstraint: NSLayoutConstraint!

    private var colorSliderStackViewExpandedHeight: CGFloat = 0

    var isExpanded: Bool {
        get {
            return colorSliderWrapperView.alpha == 1
        }
        set {
            if newValue {
                UIView.animate(withDuration: 1) {
                    self.colorSliderWrapperView.alpha = 1
                    self.colorSliderWrapperViewHeightConstraint.constant = self.colorSliderStackViewExpandedHeight
                }

            } else {
                colorSliderWrapperView.alpha = 0
                colorSliderWrapperViewHeightConstraint.constant = 0
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        colorSliderStackViewExpandedHeight = colorSliderWrapperViewHeightConstraint.constant
        isExpanded = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            isExpanded = !isExpanded
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
//        colorView.color = UIColor(color)
        colorView.backgroundColor = UIColor(color)
    }
    
    @IBAction func colorChanged(_ sender: Any) {
        updateColorView()
        delegate?.colorTableViewCellColorDidChange(self)
    }
}
