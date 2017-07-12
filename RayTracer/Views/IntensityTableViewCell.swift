//
//  IntensityTableViewCell.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/11/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import UIKit


protocol IntensityTableViewCellDelegate: class {
    func intensityTableViewCellIntensityDidChange(_ cell: IntensityTableViewCell)
}


class IntensityTableViewCell: UITableViewCell {

    weak var delegate: IntensityTableViewCellDelegate?

    var intensity: Light.Intensity {
        get {
            let rawValue = 0.5 + Double(intensityControl.selectedSegmentIndex) / 2
            return Light.Intensity(rawValue: rawValue)!
        }
        set {
            let selectedSegmentIndex = Int((newValue.rawValue - 0.5) * 2)
            intensityControl.selectedSegmentIndex = selectedSegmentIndex
        }
    }

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = NSLocalizedString("Intensity", comment: "The title text for the light intensity editing cell")
        }
    }

    @IBOutlet weak var intensityControl: UISegmentedControl!
    
    @IBAction func intensityControlValueChanged(_ sender: UISegmentedControl) {
        delegate?.intensityTableViewCellIntensityDidChange(self)
    }
}
