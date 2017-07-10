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
            return Point(x: Double(xSlider.value).roundTo(places: 1),
                         y: Double(ySlider.value).roundTo(places: 1),
                         z: Double(zSlider.value).roundTo(places: 1))
        }
        set {
            xSlider.value = Float(newValue.x)
            ySlider.value = Float(newValue.y)
            zSlider.value = Float(newValue.z)
            updateCoordinatesLabel()
        }
    }

    var pointType: PointType?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coordinatesLabel: UILabel!
    @IBOutlet weak var slidersWrapperView: UIView!
    @IBOutlet weak var slidersWrapperViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var xSlider: UISlider!
    @IBOutlet weak var ySlider: UISlider!
    @IBOutlet weak var zSlider: UISlider!

    private var slidersWrapperViewExpandedHeight: CGFloat = 0

    var isExpanded: Bool {
        get {
            return slidersWrapperView.alpha == 1
        }
        set {
            if newValue {
                UIView.animate(withDuration: 1) {
                    self.slidersWrapperView.alpha = 1
                    self.slidersWrapperViewHeightConstraint.constant = self.slidersWrapperViewExpandedHeight
                }

            } else {
                slidersWrapperView.alpha = 0
                slidersWrapperViewHeightConstraint.constant = 0
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = NSLocalizedString("Position", comment: "The title text for the position editing cell")
        slidersWrapperViewExpandedHeight = slidersWrapperViewHeightConstraint.constant
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
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        updateCoordinatesLabel()
        delegate?.pointTableViewCellPointDidChange(self)
    }
}
