//
//  SegmentedControlTableViewCell.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/12/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import UIKit


protocol SegmentedControlTableViewCellDelegate: class {
    func segmentedControlTableViewCellSegmentedControlValueDidChange(_ cell: SegmentedControlTableViewCell)
}


final class SegmentedControlTableViewCell: UITableViewCell {

    weak var delegate: SegmentedControlTableViewCellDelegate?

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var segmentedControl: UISegmentedControl!

    enum ValueType {
        case intensity, aspectRatio
    }

    var valueType: ValueType = .intensity {
        didSet {
            switch valueType {
            case .intensity:
                titleLabel.text = NSLocalizedString("Intensity", comment: "The title text for the light intensity editing cell")
                segmentedControl.setTitle(NSLocalizedString("Low", comment: "The control text for the low light intensity setting"), forSegmentAt: 0)
                segmentedControl.setTitle(NSLocalizedString("Medium", comment: "The control text for the medium light intensity setting"), forSegmentAt: 1)
                segmentedControl.setTitle(NSLocalizedString("High", comment: "The control text for the medium light intensity setting"), forSegmentAt: 2)
            case .aspectRatio:
                titleLabel.text = NSLocalizedString("Aspect Ratio", comment: "The title text for the frame aspect ratio editing cell")
                segmentedControl.setTitle(NSLocalizedString("Freeform", comment: "The control text for the freeform aspect ratio setting"), forSegmentAt: 0)
                segmentedControl.setTitle(NSLocalizedString("4:3", comment: "The control text for the 4:3 aspect ratio setting"), forSegmentAt: 1)
                segmentedControl.setTitle(NSLocalizedString("16:9", comment: "The control text for the 16:9 aspect ratio setting"), forSegmentAt: 2)
            }
        }
    }

    var intensity: Light.Intensity? {
        get {
            if valueType == .intensity {
                return Light.Intensity(rawValue: segmentedControl.selectedSegmentIndex)
            } else {
                return nil
            }
        }
        set {
            if let newValue = newValue {
                segmentedControl.selectedSegmentIndex = newValue.rawValue
            }
        }
    }

    var aspectRatio: Frame.AspectRatio? {
        get {
            if valueType == .aspectRatio {
                return Frame.AspectRatio(rawValue: segmentedControl.selectedSegmentIndex)
            } else {
                return nil
            }
        }
        set {
            if let newValue = newValue {
                segmentedControl.selectedSegmentIndex = newValue.rawValue
            }
        }
    }

    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        delegate?.segmentedControlTableViewCellSegmentedControlValueDidChange(self)
    }
}
