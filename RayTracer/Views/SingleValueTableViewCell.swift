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

    func singleValueTableViewCellDidBeginEditing(_ cell: SingleValueTableViewCell)
}


class SingleValueTableViewCell: UITableViewCell {

    weak var delegate: SingleValueTableViewCellDelegate?

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var valueTextField: UITextField! {
        didSet {
            valueTextField.delegate = self
        }
    }

    var value: Double {
        get {
            return Double(valueTextField.text!) ?? 0
        }
        set {
            valueTextField.text = String(newValue)
        }
    }
    
    @IBAction func textFieldEditingDidEnd(_ sender: UITextField) {
        delegate?.singleValueTableViewCellValueDidChange(self)
    }
}


extension SingleValueTableViewCell: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.singleValueTableViewCellDidBeginEditing(self)
    }
}
