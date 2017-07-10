//
//  SingleValueTableViewCell.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/9/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import UIKit


protocol SingleValueTableViewCellDelegate: class {
    func singleValueTableViewCellValueDidChange(_ cell: SingleValueTableViewCell)
}


class SingleValueTableViewCell: UITableViewCell {

    weak var delegate: SingleValueTableViewCellDelegate?

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var valueTextField: UITextField!

    var value: Double {
        get {
            return Double(valueTextField.text!) ?? 0
        }
        set {
            valueTextField.text = String(newValue)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func textFieldEditingDidEnd(_ sender: UITextField) {
        delegate?.singleValueTableViewCellValueDidChange(self)
    }
}
