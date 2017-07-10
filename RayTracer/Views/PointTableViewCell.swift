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

enum PointType {
    case eye, light
}

class PointTableViewCell: UITableViewCell {

    weak var delegate: PointTableViewCellDelegate?

    var point: Point {
        get {
            let xCoordinate = Double(xTextField.text!) ?? 0
            let yCoordinate = Double(yTextField.text!) ?? 0
            let zCoordinate = Double(zTextField.text!) ?? 0
            return Point(x: xCoordinate, y: yCoordinate, z: zCoordinate)
        }
        set {
            xTextField.text = String(newValue.x)
            yTextField.text = String(newValue.y)
            zTextField.text = String(newValue.z)
            updateCoordinatesLabel()
        }
    }

    var pointType: PointType?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coordinatesLabel: UILabel!
    @IBOutlet weak var coordinateDetailWrapperView: UIView!
    @IBOutlet weak var coordinateDetailWrapperViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var xTextField: UITextField!
    @IBOutlet weak var yTextField: UITextField!
    @IBOutlet weak var zTextField: UITextField!

    private var coordinateDetailStackViewExpandedHeight: CGFloat = 0

    var isExpanded: Bool {
        get {
            return coordinateDetailWrapperView.alpha == 1
        }
        set {
            if newValue {
                UIView.animate(withDuration: 1) {
                    self.coordinateDetailWrapperView.alpha = 1
                    self.coordinateDetailWrapperViewHeightConstraint.constant = self.coordinateDetailStackViewExpandedHeight
                }

            } else {
                coordinateDetailWrapperView.alpha = 0
                coordinateDetailWrapperViewHeightConstraint.constant = 0
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = NSLocalizedString("Position", comment: "The title text for the position editing cell")
        coordinateDetailStackViewExpandedHeight = coordinateDetailWrapperViewHeightConstraint.constant
        isExpanded = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            isExpanded = !isExpanded
        }
    }

    private func updateCoordinatesLabel() {
        let point = self.point
        coordinatesLabel.text = "(\(point.x), \(point.y), \(point.z))"
    }
    
    @IBAction func pointChanged(_ sender: UITextField) {
        updateCoordinatesLabel()
        delegate?.pointTableViewCellPointDidChange(self)
    }
}
