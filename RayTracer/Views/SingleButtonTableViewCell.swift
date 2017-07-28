//
//  SingleButtonTableViewCell.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/9/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import UIKit


final class SingleButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var button: UIButton!

    override func prepareForReuse() {
        button.removeTarget(nil, action: nil, for: .touchUpInside)
    }
}
