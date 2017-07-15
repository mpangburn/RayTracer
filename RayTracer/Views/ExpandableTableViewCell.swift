//
//  ExpandableTableViewCell.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/8/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import UIKit


class ExpandableTableViewCell: UITableViewCell {

    var expandableView = UIView()

    var expandableViewHeightConstraint = NSLayoutConstraint() {
        didSet {
            expandedViewHeight = expandableViewHeightConstraint.constant
        }
    }

    var expandedViewHeight: CGFloat = 0

    var isExpanded: Bool {
        get {
            return expandableView.alpha == 1
        }
        set {
            if newValue {
                UIView.animate(withDuration: 1) {
                    self.expandableView.alpha = 1
                    self.expandableViewHeightConstraint.constant = self.expandedViewHeight
                }
            } else {
                expandableView.alpha = 0
                expandableViewHeightConstraint.constant = 0
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        isExpanded = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            isExpanded = !isExpanded
        }
    }
}
